(->
  angular = require 'angular'

  Tasks = ($scope, $uibModal, Task, growl)->
    init = ()=>
      @cancelEdit = cancelEdit
      @create = create
      # @deadlinePicker = opened: off
      # @deadlinePickerOptions = showWeeks: off, startingDay: 1
      @edit = edit
      # @openDeadlinePicker = openDeadlinePicker
      @showBell = showBell
      @showDeadlineTip = showDeadlineTip
      @toggleStatus = toggleStatus
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

    edit = (task, property)=>
      clearEditing()
      @currentTask = task
      @backedupTask = angular.copy task
      @editingProperty = property

    # openDeadlinePicker = ()=>
      # @currentTask.deadline = new Date @currentTask.deadline
      # @deadlinePicker.opened = on

    showBell = (task)->
      !!task.deadline && !task.done && new Date(task.deadline) < Date.now()

    showDeadlineTip = (task)->
      return 'Set deadline' unless task.deadline
      'Edit deadline: ' + (new Date(task.deadline)).toLocaleDateString()

    toggleStatus = (task)=>
      clearEditing()
      @currentTask = task
      update()

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
      @editingProperty = ''

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
