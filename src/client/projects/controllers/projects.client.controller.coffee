(->
  angular = require 'angular'

  Projects = ($scope, RemoveModal, Project, growl)->
    init = ()=>
      @add = ()-> @newProject = {}
      @create = create
      @edit = edit
      @find = find
      @remove = remove
      @update = update

      activate()

    create = ()=>
      project = new Project name: @newProject.name

      project.$save().then (response)=>
        @projects.push response
      , (errorResponse)->
        growl.error errorResponse.data.errors[0], ttl: -1

      @newProject = null

    edit = (project)=>
      @newProject = null
      # or extend?
      # @backedupProject = angular.copy project
      @backedupProject = angular.extend {}, project
      @projectBeingEdited = angular.extend {}, project

    find = ()=>
      Project.query().$promise.then (response) =>
        @projects = response
      , (errorResponse)->
        growl.error errorResponse.data.errors[0], ttl: -1

    remove = (project, projectIndex)=>
      options = entity: 'project', caption: project.name
      RemoveModal.open(options).result.then ()=>
        project.$remove().then ()=>
          @projects.splice projectIndex, 1
        , (errorResponse)->
          growl.error errorResponse.data.errors[0], ttl: -1

    update = (project)=>
      project.$update().then ()=>
        # and extend again?
        # @backedupProject = null if @backedupProject
        @projectBeingEdited = null
      , (errorResponse)=>
        # project.name = @backedupProject.name if @backedupProject
        project.name = @backedupProject.name
        growl.error errorResponse.data.errors[0], ttl: -1

    activate = ()->
      find()

    init()
    return

  Projects.$inject = ['$scope', 'RemoveModal', 'Project', 'growl']

  angular.module('projects').controller('Projects', Projects)
)()
