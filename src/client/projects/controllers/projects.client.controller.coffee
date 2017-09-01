angular = require 'angular'
angular.module('projects').controller 'ProjectsController',
  ['$scope', '$routeParams', 'Projects', 'Identity', 'growl',
    ($scope, $routeParams, Projects, Identity, growl) ->
      $scope.identity = Identity

      clearEditing = () ->
        if $scope.currentTask
          $scope.currentTask = null
        # if $scope.currentTaskCopy
        #   $scope.currentTaskCopy = null
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
          project.tasks.push content: project.newTask.content
          $scope.backedupTask = angular.copy project.newTask
          project.newTaskContent = undefined
          $scope.update project
        else
          # $scope.error.data = {}
          # $scope.error.data.errorMessages = ['Cannot add empty task']
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
        # console.log 'cancel editing fired...'
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
          $scope.currentTaskCopy.deadlineD =
            new Date($scope.currentTaskCopy.deadline)
        else
          $scope.currentTaskCopy.deadlineD = new Date()
        # console.log $scope.currentTaskCopy
        $scope.taskEditingProperty = 'deadline'

      $scope.cancelEditTaskDeadline = () ->
        clearEditing()

      $scope.saveTaskDeadline = (task, project) ->
        task.deadline = $scope.currentTaskCopy.deadlineD
        clearEditing()
        $scope.update project

      $scope.changePriority = (index, project, event) ->
        clearEditing()
        unless event.ctrlKey
          unless index is 0
            task = project.tasks.splice index, 1
            project.tasks.splice (index - 1), 0, task[0]
            $scope.update project
        else
          unless index is project.tasks.length
            task = project.tasks.splice index, 1
            project.tasks.splice (index + 1), 0, task[0]
            $scope.update project

      $scope.removeTask = (project, taskIndex) ->
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
        if $scope.newProject.name
          project = new Projects name: $scope.newProject.name

          project.$save userId: @identity.user._id, (response) ->
            # response.newTask = {}
            $scope.projects.push response
            $scope.newProject = null
            $scope.error = []
          , (errorResponse) ->
            $scope.error = errorResponse
            $scope.newProject = null
        else
          growl.error 'New project should have a name'

      $scope.update = (project, task) ->
        project.$update userId: @identity.user._id, () ->
          # console.log 'project updated'
          # console.log project
          $scope.error = []
          if $scope.backedupProject
            $scope.backedupProject = null
          if $scope.backedupTask
            $scope.backedupTask = null
        , (errorResponse) ->
          $scope.error = errorResponse
          # console.log $scope.backedupProject
          if task && $scope.backedupTask
            task.content = $scope.backedupTask.content
          # console.log project
          if $scope.backedupProject
            project.name = $scope.backedupProject.name
          # console.log project


      $scope.delete = (project, projectIndex) ->
        project.$remove userId: @identity.user._id, () ->
          $scope.projects.splice projectIndex, 1
          $scope.error = []
        , (errorResponse) ->
          $scope.error = errorResponse

      $scope.find = () ->
        $scope.projects = Projects.query userId: @identity.user.id
        # $scope.error = null
        , (errorResponse) ->
          $scope.error = errorResponse

      $scope.find()
    ]
