(->
  unicodeRegExp = require 'unicoderegexp'
  angular = require 'angular'

  Projects = ($scope, $routeParams, $uibModal, Projects, Identity, growl)->
    init = ()=>
      @add = add
      @closeRemoveModal = closeRemoveModal
      @create = create
      @dismissRemoveModal = dismissRemoveModal
      @edit = edit
      @find = find
      @identity = Identity
      @remove = remove
      @update = update

      activate()

    add = ()=>
      @newProject = {}

    closeRemoveModal = ()->
      @modalInstance.close()
      @entityBeingRemoved = null

    create = ()=>
      project = new Projects name: @newProject.name

      project.$save(userId: @identity.user.id).then (response)=>
        @projects.push response
      , (errorResponse)->
        growl.error errorResponse.data.errors[0], ttl: -1

      @newProject = null

    dismissRemoveModal = ()->
      @modalInstance.dismiss()
      @entityBeingRemoved = null

    edit = (project)=>
      @newProject = null
      @backedupProject = angular.copy project
      @projectBeingEdited = project

    find = ()=>
      # '=' in promise success is crucial
      Projects.query(userId: @identity.user.id).$promise.then (response) =>
        @projects = response
      , (errorResponse)->
        growl.error errorResponse.data.errors[0], ttl: -1

    remove = (project, projectIndex)=>
      @entityBeingRemoved = project.name
      openRemoveModal()
      @modalInstance.result.then ()=>
        project.$remove(userId: @identity.user.id).then ()=>
          @projects.splice projectIndex, 1
        , (errorResponse)->
          growl.error errorResponse.data.errors[0], ttl: -1

    update = (project)=>
      project.$update(userId: @identity.user.id).then ()=>
        @backedupProject = null if @backedupProject
        @projectBeingEdited = null
      , (errorResponse)=>
        project.name = @backedupProject.name if @backedupProject
        growl.error errorResponse.data.errors[0], ttl: -1

    activate = ()->
      find()

    openRemoveModal = ()=>
      @modalInstance = $uibModal.open
        templateUrl: 'projects/views/remove-modal.client.view.html'
        size: 'sm'
        scope: $scope

    # vm.saveProjectName = (project) ->r
      # if project.name
        # vm.update project, null, vm.backedupProject
        # vm.projectBeingEdited = null
      # else
        # growl.error "Project name cannot be empty"
        # project.name = vm.backedupProject.name

    # clearEditing = ->
      # vm.currentTask = null if vm.currentTask
      # vm.taskEditingProperty = ''

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

    # vm.editTaskContent = (task) ->
      # clearEditing()
      # vm.currentTask = task
      # vm.currentTaskCopy = angular.copy task
      # vm.backedupTask = angular.copy task
      # vm.taskEditingProperty = 'content'

    # vm.cancelEditTaskContent = () ->
      # clearEditing()

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

  Projects.$inject = ['$scope', '$routeParams', '$uibModal',
                      'Projects', 'Identity', 'growl']

  angular.module('projects').controller 'Projects', Projects
)()
