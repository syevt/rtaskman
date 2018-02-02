(->
  projects = ($resource)->
    return $resource 'api/v1/projects/:projectId',
      projectId: '@id'
    ,
      update:
        method: 'PUT'

  projects.$inject = ['$resource']

  require('angular').module('projects').factory('Projects', projects)
)()
