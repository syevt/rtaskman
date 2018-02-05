(->
  angular = require 'angular'

  Tasks = ($scope, $uibModal, Task, growl)->
    init = ()=>
      @cancelEditContent = cancelEditContent
      @create = create
      @editContent = editContent

    cancelEditContent = ()->
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
      console.log @parentProject
      # console.log $scope
      # console.log $scope.$parent.project
      # console.log $scope.project
      clearEditing()
      @currentTask = task
      @currentTaskCopy = angular.copy task
      @backedupTask = angular.copy task
      @taskEditingProperty = 'content'

    clearEditing = ()=>
      @currentTask = null if @currentTask
      @taskEditingProperty = ''

    # vm.saveProjectName = (project) ->r
      # if project.name
        # vm.update project, null, vm.backedupProject
        # vm.projectBeingEdited = null
      # else
        # growl.error "Project name cannot be empty"
        # project.name = vm.backedupProject.name

    # vm.addTaskToProject = (project) ->
      # if project.newTask
        # project.tasks ?= []
        # project.tasks.push content: project.newTask.content
        # vm.backedupTask = angular.copy project.newTask
        # project.newTask.content = null
        # vm.update project
      # else
        # growl.error 'New task should have content'

    # vm.toggleStatus = (task, project) ->
      # clearEditing()
      # vm.update project

    # vm.saveTaskContent = (task, project) ->
      # content = vm.currentTaskCopy.content
      # unicodeRange = unicodeRegExp.letter.source
      # unicodeRange = unicodeRange.substring(1, unicodeRange.length - 1)
      # regex = new RegExp "^[#{unicodeRange}\\s-.]+$"
      # # console.log unicodeRange
      # # console.log regex
      # # console.log content.match regex
      # # console.log !!(content.match regex)
      # if content
        # if content.match regex
          # task.content = vm.currentTaskCopy.content
          # clearEditing()
          # vm.update project, task
        # else
          # growl.error "Task content should only contain letters, digits,\
            # '-' and '.'"
          # vm.currentTaskCopy.content = vm.backedupTask.content
      # else
        # growl.error "Task content cannot be empty"

      # # if vm.currentTaskCopy.content
        # # task.content = vm.currentTaskCopy.content
        # # clearEditing()
        # # vm.update project, task
      # # else
        # # vm.currentTaskCopy.content = vm.backedupTask.content
        # # growl.error "Task content cannot be empty"

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
