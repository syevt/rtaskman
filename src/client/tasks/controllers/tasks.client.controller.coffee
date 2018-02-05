(->
  angular = require 'angular'

  Tasks = ($scope, $uibModal, Task, growl)->
    init = ()=>
      @cancelEdit = cancelEdit
      @create = create
      @edit = edit
      @remove = remove
      @showBell = showBell
      @showDeadlineTip = showDeadlineTip
      @today = new Date()
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
      task.deadline = new Date(task.deadline) if property is 'deadline'
      @currentTask = task
      @backedupTask = angular.copy task
      @editingProperty = property

    remove = (task, index)=>
      console.log task.deadline
      console.log @today

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
