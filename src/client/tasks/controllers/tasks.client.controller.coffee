(->
  angular = require 'angular'

  Tasks = ($scope, $uibModal, Task, growl)->
    init = ()=>
      @cancelEdit = cancelEdit
      @create = create
      @editContent = editContent
      @update = update

    cancelEdit = ()->
      clearEditing()

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

    editContent = (task)=>
      clearEditing()
      @currentTask = task
      @backedupTask = angular.copy task
      @taskEditingProperty = 'content'

    update = ()=>
      task = new Task @currentTask
      task.$update().then ()=>
        @currentTask = null
        @backedupTask = null
      , (errorResponse)=>
        @currentTask = @backedupTask if @backedupTask
        growl.error errorResponse.data.errors[0], ttl: -1

    clearEditing = ()=>
      @currentTask = null if @currentTask
      @taskEditingProperty = ''

    # vm.toggleStatus = (task, project) ->
      # clearEditing()
      # vm.update project

    # vm.editTaskDeadline = (task) ->
      # clearEditing()
      # vm.currentTask = task
      # vm.currentTaskCopy = angular.copy task
      # if vm.currentTaskCopy.deadline
        # vm.currentTaskCopy.deadline =
          # new Date(vm.currentTaskCopy.deadline)
      # else
        # vm.currentTaskCopy.deadline = new Date()
      # vm.taskEditingProperty = 'deadline'

    # vm.openDeadlinePicker = ->
      # vm.deadlinePicker.opened = on

    # vm.deadlinePicker =
      # opened: off

    # vm.deadlinePickerOptions =
      # showWeeks: off
      # startingDay: 1

    # vm.cancelEditTaskDeadline = () ->
      # clearEditing()

    # vm.saveTaskDeadline = (task, project) ->
      # task.deadline = vm.currentTaskCopy.deadline
      # clearEditing()
      # vm.update project

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

    # vm.taskShowBell = (task) ->
      # if task.deadline
        # !task.done and new Date(task.deadline) < Date.now()

    # vm.showDeadline = (task) ->
      # if task.deadline
        # return 'Edit deadline: ' + (new Date(task.deadline)).toLocaleDateString()
      # else
        # return 'Set deadline'

    init()
    return

  Tasks.$inject = ['$scope', '$uibModal', 'Task', 'growl']

  angular.module('tasks').controller('Tasks', Tasks)
)()
