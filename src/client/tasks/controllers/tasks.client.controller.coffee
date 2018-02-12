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

    cancelEdit = ()=>
      @currentTask = null
      @editingProperty = ''

    create = ()=>
      task = new Task
        project_id: @parentProject.id
        content: @parentProject.newTask.content
        priority: @parentProject.tasks.length

      task.$save().then (response)=>
        @parentProject.tasks.push(response)
        @parentProject.newTask = null
      , (errorResponse)->
        growl.error(errorResponse.data.errors[0], ttl: -1)

    deadlineTip = (deadline)->
      return 'Set deadline' unless deadline
      'Edit deadline: ' + moment.utc(deadline).format('LL')

    edit = (task, property)=>
      @backedupTask = angular.extend({}, task)
      @currentTask = angular.extend({}, task)
      @editingProperty = property

    remove = (task, index)->
      console.log task.deadline

    showBell = (task)->
      !!task.deadline && !task.done &&
        moment.utc(task.deadline).add(1, 'd') < moment.utc()

    toggleStatus = (task)->
      edit(task, '')
      update(task)

    update = (task)=>
      taskBeingEdited = new Task(@currentTask)
      taskBeingEdited.$update().then (response)=>
        angular.extend task, response
        @currentTask = null
      , (errorResponse)=>
        angular.extend(@currentTask, @backedupTask)
        growl.error(errorResponse.data.errors[0], ttl: -1)

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
