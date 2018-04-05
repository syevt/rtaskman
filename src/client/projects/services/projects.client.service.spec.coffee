describe 'Project resource', ()->
  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('Project', '$httpBackend')

  context 'query()', ()->
    it 'with successful response returns projects array', ()->
      projects = []
      $httpBackend.when('GET', 'api/v1/projects')
        .respond(200, [{name: 'foo'}, {name: 'bar'}])
      Project.query().$promise.then (response)->
        projects = response
      $httpBackend.flush()
      expect(projects.length).to.eq(2)
      expect(projects[1].name).to.eq('bar')

    it 'with error response returns error', ()->
      error = {}
      getError = 'get projects error'
      $httpBackend.when('GET', 'api/v1/projects')
        .respond(500, errors: [getError])
      Project.query().$promise.catch (errorResponse)->
        error = errorResponse.data.errors[0]
      $httpBackend.flush()
      expect(error).to.eq(getError)

  context '#save', ()->
    it 'with successful response returns saved project', ()->
      name = 'new project'
      savedProject = {}
      $httpBackend.when('POST', 'api/v1/projects').respond(200, name: name)
      new Project(name: 'foo').$save().then (response)->
        savedProject = response
      $httpBackend.flush()
      expect(savedProject.name).to.eq(name)

    it 'with error response returns error', ()->
      error = {}
      createError = 'create project error'
      $httpBackend.when('POST', 'api/v1/projects')
        .respond(500, errors: [createError])
      new Project(name: 'foo').$save().catch (errorResponse)->
        error = errorResponse.data.errors[0]
      $httpBackend.flush()
      expect(error).to.eq(createError)

  context '#put and #remove', ()->
    project = {}

    beforeEach ()->
      project = new Project(id: 1, name: 'foo')

    context '#put', ()->
      it 'with successful response updates project fields', ()->
        name = 'updated project name'
        $httpBackend.when('PUT', "api/v1/projects/#{project.id}")
          .respond(200, name: name)
        project.$update()
        $httpBackend.flush()
        expect(project.name).to.eq(name)

      it 'with error response returns error', ()->
        error = {}
        updateError = 'update project error'
        $httpBackend.when('PUT', "api/v1/projects/#{project.id}")
          .respond(500, errors: [updateError])
        project.$update().catch (errorResponse)->
          error = errorResponse.data.errors[0]
        $httpBackend.flush()
        expect(error).to.eq(updateError)

    context '#remove', ()->
      it 'with successful response returns deleted project', ()->
        name = 'deleted project name'
        $httpBackend.when('DELETE', "api/v1/projects/#{project.id}")
          .respond(200, name: name)
        project.$remove()
        $httpBackend.flush()
        expect(project.name).to.eq(name)

      it 'with error response returns error', ()->
        error = {}
        removalError = 'removal project error'
        $httpBackend.when('DELETE', "api/v1/projects/#{project.id}")
          .respond(500, errors: [removalError])
        project.$remove().catch (errorResponse)->
          error = errorResponse.data.errors[0]
        $httpBackend.flush()
        expect(error).to.eq(removalError)
