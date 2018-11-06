(->
  Project = ($resource)->
    return $resource 'api/v1/projects/:projectId',
      projectId: '@id'
    ,
      update:
        method: 'PUT'

  Project.$inject = ['$resource']

  require('angular').module('projects').factory('Project', Project)
)()
