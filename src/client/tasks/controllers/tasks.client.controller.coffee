(->
  angular = require 'angular'
  moment = require 'moment'

  Tasks = ($scope, $uibModal, Task, growl)->
    init = ()=>
      @cancelEdit = cancelEdit
      @create = create
      @deadlineTip = deadlineTip
      @edit = edit
      @remove = remove
      @showBell = showBell
      @toggleStatus = toggleStatus
      @update = update

    cancelEdit = (task)=>
      clearEditing()
      angular.extend task, @backedupTask

    create = ()=>
      task = new Task
        project_id: @parentProject.id
        content: @parentProject.newTask.content
        priority: @parentProject.tasks.length

      task.$save().then (response)=>
        @parentProject.tasks.push response
        @parentProject.newTask = null
      , (errorResponse)->
        growl.error errorResponse.data.errors[0], ttl: -1

    deadlineTip = (deadline)->
      return 'Set deadline' unless deadline
      'Edit deadline: ' + (new Date(deadline)).toLocaleDateString()
      # maybe moment.toString?

    edit = (task, property)=>
      console.log task
      @backedupTask = angular.extend {}, task
      @currentTask = angular.extend {}, task
      # clearEditing()
      setDeadline(task) if @editingProperty is 'deadline'
      @editingProperty = property

    remove = (task, index)->
      d = moment.utc(task.deadline)
      console.log d
      n = moment.utc().startOf('date')
      console.log n
      console.log d.isAfter n

    showBell = (task)->
      !!task.deadline && !task.done &&
        moment.utc(task.deadline).isBefore moment.utc().startOf('date')
        # new Date(task.deadline) < (new Date()).setUTCHours(0,0,0,0)

    toggleStatus = (task)=>
      clearEditing()
      # setDeadline(task)
      @currentTask = task
      update()

    update = (task)=>
      taskBeingEdited = new Task @currentTask
      taskBeingEdited.$update().then (response)=>
        angular.extend task, response
        @currentTask = null
      , (errorResponse)=>
        angular.extend @currentTask, @backedupTask
        growl.error errorResponse.data.errors[0], ttl: -1

    clearEditing = ()=>
      @currentTask = null if @currentTask
      @editingProperty = ''

    setDeadline = (task)->
      date = task.deadline
      # task.deadline = if date then (new Date(date)) else (new Date())
      task.deadline = if date then moment.utc(date) else moment.utc()
      # moment() ???

    # vm.removeTask = (project, task, taskIndex) ->
      # vm.entityBeingRemoved = task.content
      # vm.modalInstance = $uibModal.open
        # templateUrl: 'projects/views/remove-modal.client.view.html'
        # size: 'sm'
        # scope: $scope
      # vm.modalInstance.result.then () ->
        # clearEditing()
        # project.tasks.splice taskIndex, 1
        # vm.update project

    init()
    return

  Tasks.$inject = ['$scope', '$uibModal', 'Task', 'growl']

  angular.module('tasks').controller('Tasks', Tasks)
)()
