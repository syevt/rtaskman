require('angular').module('users').factory 'Users', [ '$resource',
  ($resource) ->
    $resource 'api/users/:userId', userId: '@_id',
      update:
        method: 'PUT'
  ]