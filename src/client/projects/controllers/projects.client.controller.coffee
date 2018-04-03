(->
  angular = require('angular')

  Projects = (Project, removalModal, growl, $translate)->
    init = ()=>
      @add = ()-> @newProject = {}
      @create = create
      @edit = edit
      @find = find
      @remove = remove
      @update = update

      activate()

    create = ()=>
      project = new Project(name: @newProject.name)

      project.$save().then (response)=>
        @projects.push(response)
      , (errorResponse)->
        growl.error(errorResponse.data.errors[0], ttl: -1)

      @newProject = null

    edit = (project)=>
      @newProject = null
      @backedupProject = angular.extend({}, project)
      @currentProject = angular.extend({}, project)

    find = ()=>
      Project.query().$promise.then (response)=>
        @projects = response
      , (errorResponse)->
        growl.error(errorResponse.data.errors[0], ttl: -1)

    remove = (project, projectIndex)=>
      projectTranslation = $translate.instant('projects.project')
      removalModal.open(projectTranslation, project.name).result.then ()=>
        project.$remove().then ()=>
          @projects.splice(projectIndex, 1)
        , (errorResponse)->
          growl.error(errorResponse.data.errors[0], ttl: -1)

    update = (project)=>
      projectBeingUpdated = new Project(@currentProject)
      projectBeingUpdated.$update().then (response)=>
        angular.extend(project, response)
        @currentProject = null
      , (errorResponse)=>
        angular.extend(@currentProject, @backedupProject)
        growl.error(errorResponse.data.errors[0], ttl: -1)

    activate = ()->
      find()

    init()
    return

  Projects.$inject = ['Project', 'removalModal', 'growl', '$translate']

  angular.module('projects').controller('Projects', Projects)
)()
