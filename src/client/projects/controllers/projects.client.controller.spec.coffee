describe 'Projects', ()->
  controller = {}
  fakeProjects = [{name: 'first'}, {name: 'second'}]
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$controller', '$q', '$rootScope', 'Project',
                'removalModal', 'growl', '$translate')
    controller = $controller('Projects')

  afterEach ()->
    sandbox.restore()

  context '#add', ()->
    it 'assigns empty object to @newProject', ()->
      controller.add()
      expect(controller.newProject).to.empty

  context '#create', ()->
    beforeEach ()->
      controller.projects = [{name: 'one'}, {name: 'two'}]
      controller.newProject = name: 'third'

    context 'with successful response', ()->
      beforeEach ()->
        sandbox.stub(Project.prototype, '$save')
          .returns($q.when(name: 'fourth'))
        controller.create()
        $rootScope.$apply()

      it 'adds new project to user`s projects', ()->
        expect(controller.projects).to.deep.include(name: 'fourth')
      it 'nullifies @newProject', ()->
        expect(controller.newProject).to.be.null

    context 'with error response', ()->
      error = 'adding error'
      beforeEach ()->
        sandbox.spy(growl, 'error')
        sandbox.stub(Project.prototype, '$save')
          .returns($q.reject(data: {errors: [error]}))
        controller.create()
        $rootScope.$apply()

      it 'makes growl show error message', ()->
        expect(growl.error).to.have.been.calledWith(error, ttl: -1)
      it 'nullifies @newProject', ()->
        expect(controller.newProject).to.be.null

  context '#edit', ()->
    project = name: 'agenda'

    beforeEach ()->
      controller.newProject = {}
      controller.edit(project)

    it 'nullifies @newProject', ()->
      expect(controller.newProject).to.be.null

    it 'backs up the project being edited', ()->
      expect(controller.backedupProject).to.include(project)

    it 'sets current project`s values to those of the project being edited', ()->
      expect(controller.currentProject).to.include(project)

  context '#find', ()->
    it 'with successful response assings response to @projects', ()->
      sandbox.stub(Project, 'query').returns($promise: $q.when(fakeProjects))
      controller.find()
      $rootScope.$apply()
      expect(controller.projects).to.eq(fakeProjects)

    it 'with error response makes growl show error message', ()->
      error = 'query error'
      sandbox.spy(growl, 'error')
      sandbox.stub(Project, 'query')
        .returns($promise: $q.reject(data: {errors: [error]}))
      controller.find()
      $rootScope.$apply()
      expect(growl.error).to.have.been.calledWith(error, ttl: -1)

  context '#remove', ()->
    project = {}

    beforeEach ()->
      project = new Project(name: 'some project')
      controller.projects = fakeProjects

    it 'shows removal confirmation modal', ()->
      projectTranslation = 'project'
      sandbox.stub($translate, 'instant')
        .withArgs('projects.project')
        .returns(projectTranslation)
      sandbox.spy(removalModal, 'open')
      controller.remove(project, 0)
      expect(removalModal.open).to
        .have.been.calledWith(projectTranslation, 'some project')

    it 'with successful response removes project from @projects', ()->
      sandbox.stub(removalModal, 'open').returns(result: $q.when())
      sandbox.stub(Project.prototype, '$remove').returns($q.when())
      controller.remove(project, 0)
      $rootScope.$apply()
      expect(controller.projects).not.to.deep.include(name: 'first')

    it 'with error response makes growl show error message', ()->
      error = 'removal error'
      sandbox.stub(removalModal, 'open').returns(result: $q.when())
      sandbox.stub(Project.prototype, '$remove')
        .returns($q.reject(data: {errors: [error]}))
      sandbox.spy(growl, 'error')
      controller.remove(project, 0)
      $rootScope.$apply()
      expect(growl.error).to.have.been.calledWith(error, ttl: -1)

  context '#update', ()->
    project = name: 'to update'

    beforeEach ()->
      controller.currentProject = name: 'current'
      controller.backedupProject = name: 'backed up'

    context 'with successful response', ()->
      beforeEach ()->
        sandbox.stub(Project.prototype, '$update')
          .returns($q.when(name: 'updated'))
        controller.update(project)
        $rootScope.$apply()

      it 'updates project`s properties with those of returned project', ()->
        expect(project.name).to.eq('updated')

      it 'nullifies @currentProject', ()->
        expect(controller.currentProject).to.be.null

    context 'with error response', ()->
      error = 'udate project error'

      beforeEach ()->
        sandbox.spy(growl, 'error')
        sandbox.stub(Project.prototype, '$update')
          .returns($q.reject(data: {errors: [error]}))
        controller.update(project)
        $rootScope.$apply()

      it 'restores current project`s properties from backup', ()->
        expect(controller.currentProject.name).to.eq('backed up')

      it 'makes growl show error message', ()->
        expect(growl.error).to.have.been.calledWith(error, ttl: -1)
