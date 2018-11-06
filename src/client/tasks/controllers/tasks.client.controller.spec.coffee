describe 'Tasks controller', ()->
  controller = {}
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$controller', '$q', '$rootScope', 'Task', 'removalModal',
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
    context 'with valid task content', ()->
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

    context 'with non-valid task content', ()->
      context 'with null`ed newTask', ()->
        beforeEach ()->
          controller.parentProject = tasks: []

        it "makes growl show 'empty' error", ()->
          sandbox.spy($translate, 'instant')
          sandbox.spy(growl, 'error')
          controller.create()
          expect($translate.instant).to
            .have.been.calledWith('common.emptyError')
          expect(growl.error).to.have.been.called

        it 'doesn`t add task to @parentProject.tasks', ()->
          controller.create()
          expect(controller.parentProject.tasks.length).to.eq(0)

      context 'with invalid task content', ()->
        beforeEach ()->
          controller.parentProject = newTask: {content: '*foo*'}, tasks: []

        it "makes growl show 'invalid' error", ()->
          sandbox.spy($translate, 'instant')
          sandbox.spy(growl, 'error')
          controller.create()
          expect($translate.instant).to
            .have.been.calledWith('common.invalidError')
          expect(growl.error).to.have.been.called

        it 'doesn`t add task to @parentProject.tasks', ()->
          controller.create()
          expect(controller.parentProject.tasks.length).to.eq(0)

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

    it 'backs up the task being edited', ()->
      expect(controller.backedupTask).to.include(task)

    it 'sets current task`s values to those of the task being edited', ()->
      expect(controller.currentTask).to.include(task)

    it 'sets scope`s editingProperty to the task`s updating property', ()->
      expect(controller.editingProperty).to.eq('content')

  context '#remove', ()->
    task = content: 'hard task'

    beforeEach ()->
      controller.parentProject = tasks: [{content: 'first'}, {content: 'second'}]

    it 'shows removal confirmation modal', ()->
      taskTranslation = 'task'
      sandbox.stub($translate, 'instant')
        .withArgs('tasks.task')
        .returns(taskTranslation)
      sandbox.spy(removalModal, 'open')
      controller.remove(task, 0)
      expect(removalModal.open).to
        .have.been.calledWith(taskTranslation, 'hard task')

    it 'with successful response removes task from parent project', ()->
      sandbox.stub(removalModal, 'open').returns(result: $q.when())
      sandbox.stub(Task.prototype, '$remove').returns($q.when())
      controller.remove(task, 0)
      $rootScope.$apply()
      expect(controller.parentProject.tasks).not.to.include(content: 'first')

    it 'with error response makes growl show error message', ()->
      error = 'removal error'
      sandbox.stub(removalModal, 'open').returns(result: $q.when())
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

  context '#toggleStatus', ()->
    it 'calls #edit and #update', ()->
      task = {content: 'test'}
      editSpy = sandbox.spy(controller, 'edit')
      updateSpy = sandbox.spy(controller, 'update')
      controller.toggleStatus(task)
      expect(editSpy).to.have.been.calledWith(task, '')
      expect(updateSpy.calledImmediatelyAfter(editSpy)).to.be.true

  context '#update', ()->
    task = {}

    beforeEach ()->
      task = content: 'being updated'

    context 'with valid task content', ()->
      beforeEach ()->
        controller.backedupTask = content: 'backed up'
        controller.currentTask = content: 'current'

      context 'with successful response', ()->
        beforeEach ()->
          sandbox.stub(Task.prototype, '$update')
            .returns($q.when(content: 'updated'))
          controller.update(task)
          $rootScope.$apply()

        it 'updates task properties with those returned by backend', ()->
          expect(task.content).to.eq('updated')

        it 'nullifies @currentTask', ()->
          expect(controller.currentTask).to.be.null

      context 'with error response', ()->
        error = 'update error'

        beforeEach ()->
          sandbox.spy(growl, 'error')
          sandbox.stub(Task.prototype, '$update')
            .returns($q.reject(data: {errors: [error]}))
          controller.update(task)
          $rootScope.$apply()

        it 'restores current task`s properties from backup', ()->
          expect(controller.currentTask.content).to.eq('backed up')

        it 'makes growl show error message', ()->
          expect(growl.error).to.have.been.calledWith(error, ttl: -1)

    context 'with non-valid task content', ()->
      beforeEach ()->
        controller.currentTask = content: 'to update'

      context 'with empty task content', ()->
        beforeEach ()->
          controller.currentTask = content: ''

        it "makes growl show 'empty' error", ()->
          sandbox.spy($translate, 'instant')
          sandbox.spy(growl, 'error')
          controller.update(task)
          expect($translate.instant).to
            .have.been.calledWith('common.emptyError')
          expect(growl.error).to.have.been.called

        it 'doesn`t update task content', ()->
          controller.update(task)
          expect(task.content).to.eq('being updated')

      context 'with invalid task content', ()->
        beforeEach ()->
          controller.currentTask = content: '{invalid}'

        it "makes growl show 'invalid' error", ()->
          sandbox.spy($translate, 'instant')
          sandbox.spy(growl, 'error')
          controller.update(task)
          expect($translate.instant).to
            .have.been.calledWith('common.invalidError')
          expect(growl.error).to.have.been.called

        it 'doesn`t update task content', ()->
          controller.update(task)
          expect(task.content).to.eq('being updated')
