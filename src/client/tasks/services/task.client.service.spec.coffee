describe 'Task resource', ()->
  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('Task', '$httpBackend')

  context '#save', ()->
    it 'with successful response returns saved task', ()->
      content = 'new task'
      savedTask = {}
      $httpBackend.when('POST', 'api/v1/tasks').respond(200, content: content)
      new Task(content: 'foo').$save().then (response)->
        savedTask = response
      $httpBackend.flush()
      expect(savedTask.content).to.eq(content)

    it 'with error response returns error', ()->
      error = {}
      createError = 'create task error'
      $httpBackend.when('POST', 'api/v1/tasks')
        .respond(500, errors: [createError])
      new Task(content: 'foo').$save().catch (errorResponse)->
        error = errorResponse.data.errors[0]
      $httpBackend.flush()
      expect(error).to.eq(createError)

  context '#put and #remove', ()->
    task = {}

    beforeEach ()->
      task = new Task(id: 1, content: 'foo')

    context '#put', ()->
      it 'with successful response updates task fields', ()->
        content = 'updated task content'
        $httpBackend.when('PUT', "api/v1/tasks/#{task.id}")
          .respond(200, content: content)
        task.$update()
        $httpBackend.flush()
        expect(task.content).to.eq(content)

      it 'with error response returns error', ()->
        error = {}
        updateError = 'update task error'
        $httpBackend.when('PUT', "api/v1/tasks/#{task.id}")
          .respond(500, errors: [updateError])
        task.$update().catch (errorResponse)->
          error = errorResponse.data.errors[0]
        $httpBackend.flush()
        expect(error).to.eq(updateError)

    context '#remove', ()->
      it 'with successful response returns deleted task', ()->
        content = 'deleted task content'
        $httpBackend.when('DELETE', "api/v1/tasks/#{task.id}")
          .respond(200, content: content)
        task.$remove()
        $httpBackend.flush()
        expect(task.content).to.eq(content)

      it 'with error response returns error', ()->
        error = {}
        removalError = 'removal task error'
        $httpBackend.when('DELETE', "api/v1/tasks/#{task.id}")
          .respond(500, errors: [removalError])
        task.$remove().catch (errorResponse)->
          error = errorResponse.data.errors[0]
        $httpBackend.flush()
        expect(error).to.eq(removalError)
