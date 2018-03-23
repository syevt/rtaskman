describe.only 'Tasks', ()->
  controller = {}
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$controller', '$q', '$rootScope', 'Task', 'RemoveModal',
                'growl', '$translate')
    controller = $controller('Tasks')

  afterEach ()->
    sandbox.restore()

  context '#cancelEdit', ()->
    it 'clears current task`s edited values', ()->
      controller.currentTask = {}
      controller.editingProperty = 'content'
      controller.cancelEdit()
      expect(controller.currentTask).to.be.null
      expect(controller.editingProperty).to.be.empty

  context '#create', ()->
    context 'with successful response', ()->
      beforeEach ()->
        sandbox.stub(Task.prototype, '$save').returns($q.when(content: 'foo'))
        controller.parentProject = id: 1, newTask: {content: 'bar'}, tasks: []
        controller.create()
        $rootScope.$apply()

      it 'adds new task to the project', ()->
        expect(controller.parentProject.tasks).to.deep.include(content: 'foo')

      it 'nullifies parentProject.newTask variable', ()->
        expect(controller.parentProject.newTask).to.be.null

    context 'with error response', ()->
      error = 'awful error'

      it 'makes growl show error message', ()->
        sandbox.stub(Task.prototype, '$save').returns(
          $q.reject(data: {errors: [error]}))
        sandbox.spy(growl, 'error')
        controller.parentProject = id: 1, newTask: {content: 'bar'}, tasks: []
        controller.create()
        $rootScope.$apply()
        expect(growl.error).to.have.been.calledWith(error, ttl: -1)

  context '#deadlineTip', ()->
    beforeEach ()->
      sandbox.spy($translate, 'instant')

    context 'when passing a date', ()->
      it "returns 'edit deadline' tip", ()->
        controller.deadlineTip('foo')
        expect($translate.instant).to
          .have.been.calledWith('tasks.editDeadlineHint')

      it 'with properly formatted date', ()->
        expect(controller.deadlineTip('1776-07-04')).to.include('July 4, 1776')

    context 'without date', ()->
      it "returns 'set deadline' tip", ()->
        controller.deadlineTip()
        expect($translate.instant).to
          .have.been.calledWith('tasks.setDeadlineHint')

  context '#edit', ()->
    task = id: 42, content: 'do smth', deadline: '1789-03-04'

    beforeEach ()->
      controller.edit(task, 'content')

    it 'backs up the task being updated', ()->
      expect(controller.backedupTask).to.include(task)

    it 'sets current task`s values to those of the task being updated', ()->
      expect(controller.backedupTask).to.include(task)

    it 'sets scope`s editingProperty to the task`s updating property', ()->
      expect(controller.editingProperty).to.eq('content')

  context '#remove', ()->
    task = content: 'hard task'

    beforeEach ()->
      controller.parentProject = tasks: [{content: 'first'}, {content: 'second'}]

    it 'shows removal confirmation modal', ()->
      sandbox.spy(RemoveModal, 'open')
      controller.remove(task, 0)
      expect(RemoveModal.open).to
        .have.been.calledWith(entity: 'task', caption: 'hard task')

    it 'with successful response removes task from parent project', ()->
      sandbox.stub(RemoveModal, 'open').returns(result: $q.when())
      sandbox.stub(Task.prototype, '$remove').returns($q.when())
      controller.remove(task, 0)
      $rootScope.$apply()
      expect(controller.parentProject.tasks).not.to.include(content: 'first')

    it 'with error response makes growl show error message', ()->
      error = 'removal error'
      sandbox.stub(RemoveModal, 'open').returns(result: $q.when())
      sandbox.stub(Task.prototype, '$remove')
        .returns($q.reject(data: {errors: [error]}))
      sandbox.spy(growl, 'error')
      controller.remove(task, 0)
      $rootScope.$apply()
      expect(growl.error).to.have.been.calledWith(error)

  context '#showBell', ()->
    task = {}
    dateFormat = 'YYYY-MM-DD'
    today = moment.utc().format(dateFormat)
    tomorrow = moment.utc().add(1, 'd').format(dateFormat)
    yesterday = moment.utc().add(-1, 'd').format(dateFormat)

    it 'with task without deadline returns false', ()->
      expect(controller.showBell(task)).to.be.false

    context 'with task`s deadline', ()->
      it 'equal today returns false', ()->
        task.deadline = today
        expect(controller.showBell(task)).to.be.false

      it 'greater than today returns false', ()->
        task.deadline = tomorrow
        expect(controller.showBell(task)).to.be.false

      it 'less than today returns true', ()->
        task.deadline = yesterday
        expect(controller.showBell(task)).to.be.true

      it 'less than today and task being done returns false', ()->
        task.deadline = yesterday
        task.done = on
        expect(controller.showBell(task)).to.be.false
