require('angular').module('projects').directive 'tmNewTaskForm', ->
  restrict: 'E'
  replace: on
  templateUrl: 'projects/directives/templates/\
    new-task-form.client.template.html'
