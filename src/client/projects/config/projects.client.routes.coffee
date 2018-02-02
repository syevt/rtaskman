require('angular').module('projects').config ['$routeProvider',
  ($routeProvider) ->
    $routeProvider.
    when '/users/:userId/projects',
      templateUrl: 'projects/views/list-projects.client.view.html'
      controller: 'Projects as vm'
]
