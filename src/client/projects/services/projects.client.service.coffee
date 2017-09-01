require('angular').module('projects').factory 'Projects', ['$resource',
  ($resource) ->
    return $resource 'api/v1/users/:userId/projects.json/:projectId',
      projectId: '@_id'
    ,
      update:
        method: 'PUT'
  ]
