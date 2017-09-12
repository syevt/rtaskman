angular = require 'angular'
angular.module('projects').controller 'ProjectsController',
  ['$scope', '$routeParams', '$uibModal', 'Projects', 'Identity', 'growl',
    ($scope, $routeParams, $uibModal, Projects, Identity, growl) ->
      $scope.identity = Identity

      clearEditing = () ->
        if $scope.currentTask
          $scope.currentTask = null
        $scope.taskEditingProperty = ''

      $scope.addNewProject = () ->
        $scope.newProject = {}

      $scope.editProjectName = (project) ->
        $scope.newProject = null
        $scope.backedupProject = angular.copy project
        $scope.projectBeingEdited = project

      $scope.saveProjectName = (project) ->
        if project.name
          $scope.update project, null, $scope.backedupProject
          $scope.projectBeingEdited = null
        else
          growl.error "Project name cannot be empty"
          project.name = $scope.backedupProject.name

      $scope.addTaskToProject = (project) ->
        if project.newTask
          project.tasks ?= []
          project.tasks.push content: project.newTask.content
          $scope.backedupTask = angular.copy project.newTask
          project.newTask.content = null
          $scope.update project
        else
          growl.error 'New task should have content'

      $scope.toggleStatus = (task, project) ->
        clearEditing()
        $scope.update project

      $scope.editTaskContent = (task) ->
        clearEditing()
        $scope.currentTask = task
        $scope.currentTaskCopy = angular.copy task
        $scope.backedupTask = angular.copy task
        $scope.taskEditingProperty = 'content'

      $scope.cancelEditTaskContent = () ->
        clearEditing()

      $scope.saveTaskContent = (task, project) ->
        if $scope.currentTaskCopy.content
          task.content = $scope.currentTaskCopy.content
          clearEditing()
          $scope.update project, task
        else
          $scope.currentTaskCopy.content = $scope.backedupTask.content
          growl.error "Task content cannot be empty"

      $scope.editTaskDeadline = (task) ->
        clearEditing()
        $scope.currentTask = task
        $scope.currentTaskCopy = angular.copy task
        if $scope.currentTaskCopy.deadline
          $scope.currentTaskCopy.deadline =
            new Date($scope.currentTaskCopy.deadline)
        else
          $scope.currentTaskCopy.deadline = new Date()
        $scope.taskEditingProperty = 'deadline'

      $scope.openDeadlinePicker = ->
        $scope.deadlinePicker.opened = on

      $scope.deadlinePicker =
        opened: off

      $scope.deadlinePickerOptions =
        showWeeks: off
        startingDay: 1

      $scope.cancelEditTaskDeadline = () ->
        clearEditing()

      $scope.saveTaskDeadline = (task, project) ->
        task.deadline = $scope.currentTaskCopy.deadline
        clearEditing()
        $scope.update project

      $scope.removeTask = (project, task, taskIndex) ->
        $scope.entityBeingRemoved = task.content
        $scope.modalInstance = $uibModal.open
          templateUrl: 'projects/views/remove-modal.client.view.html'
          size: 'sm'
          scope: $scope
        $scope.modalInstance.result.then () ->
          clearEditing()
          project.tasks.splice taskIndex, 1
          $scope.update project

      $scope.taskShowBell = (task) ->
        if task.deadline
          !task.done and new Date(task.deadline) < Date.now()

      $scope.showDeadline = (task) ->
        if task.deadline
          return 'Edit deadline: ' + (new Date(task.deadline)).toLocaleDateString()
        else
          return 'Set deadline'

      $scope.create = () ->
        project = new Projects
          name: $scope.newProject.name

        project.$save(userId: @identity.user.id).then (response) ->
          $scope.projects.push response
        , (errorResponse) ->
           growl.error errorResponse.data.errors[0], ttl: -1

        $scope.newProject = null

      $scope.update = (project, task) ->
        project.$update(userId: @identity.user.id).then () ->
          $scope.backedupProject = null if $scope.backedupProject
          $scope.backedupTask = null if $scope.backedupTask
        , (errorResponse) ->
          task.content = $scope.backedupTask.content if task && $scope.backedupTask
          project.name = $scope.backedupProject.name if $scope.backedupProject
          growl.error errorResponse.data.errors[0], ttl: -1

      $scope.remove = (project, projectIndex) ->
        $scope.entityBeingRemoved = project.name
        $scope.modalInstance = $uibModal.open
          templateUrl: 'projects/views/remove-modal.client.view.html'
          size: 'sm'
          scope: $scope
        $scope.modalInstance.result.then () ->
          project.$remove(userId: $scope.identity.user.id).then () ->
            $scope.projects.splice projectIndex, 1
          , (errorResponse) ->
            growl.error errorResponse.data.errors[0], ttl: -1

      $scope.closeRemoveModal = () ->
        $scope.modalInstance.close()
        $scope.entityBeingRemoved = null

      $scope.dismissRemoveModal = () ->
        $scope.modalInstance.dismiss()
        $scope.entityBeingRemoved = null

      $scope.find = () ->
        Projects.query(userId: @identity.user.id).$promise.then (response) ->
          $scope.projects = response
        , (errorResponse) ->
          growl.error errorResponse.data.errors[0], ttl: -1

      $scope.find()
    ]
