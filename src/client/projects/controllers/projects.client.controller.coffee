(->
  angular = require 'angular'

  Projects = ($scope, $uibModal, ProjectsService, growl)->
    init = ()=>
      @add = add
      @closeRemoveModal = closeRemoveModal
      @create = create
      @dismissRemoveModal = dismissRemoveModal
      @edit = edit
      @find = find
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

      project.$save().then (response)=>
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
      Projects.query().$promise.then (response) =>
        @projects = response
      , (errorResponse)->
        growl.error errorResponse.data.errors[0], ttl: -1

    remove = (project, projectIndex)=>
      @entityBeingRemoved = project.name
      openRemoveModal()
      @modalInstance.result.then ()=>
        project.$remove().then ()=>
          @projects.splice projectIndex, 1
        , (errorResponse)->
          growl.error errorResponse.data.errors[0], ttl: -1

    update = (project)=>
      project.$update().then ()=>
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

    init()
    return

  Projects.$inject = ['$scope', '$uibModal', 'ProjectsService', 'growl']

  angular.module('projects').controller('Projects', Projects)
)()
