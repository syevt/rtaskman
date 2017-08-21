require('angular').module('projects').factory 'Projects', ['$resource',
  ($resource) ->
    return $resource 'api/users/:userId/projects/:projectId',
      projectId: '@_id'
    ,
      update:
        method: 'PUT'
  ]