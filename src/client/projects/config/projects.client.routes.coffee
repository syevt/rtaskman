require('angular').module('projects').config ['$routeProvider',
  ($routeProvider) ->
    $routeProvider.
    when '/projects',
      templateUrl: 'projects/views/list-projects.client.view.html'
      controller: 'Projects as vm'
]
