require('angular').module('projects').factory 'Projects', ['$resource',
  ($resource) ->
    # return $resource 'api/v1/users/:userId/projects.json/:projectId',
    return $resource 'api/v1/users/:userId/projects/:projectId',
      projectId: '@id'
    ,
      update:
        method: 'PUT'
  ]
