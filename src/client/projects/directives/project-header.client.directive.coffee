require('angular').module('projects').directive 'tmProjectHeader', ->
  restrict: 'E'
  replace: on
  templateUrl: 'projects/directives/templates/\
    project-header.client.template.html'
