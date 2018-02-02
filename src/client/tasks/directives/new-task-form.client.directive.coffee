(->
  tmNewTaskForm = ()->
    restrict: 'E'
    replace: on
    templateUrl: 'tasks/directives/templates/\
      new-task-form.client.template.html'

  require('angular').module('tasks').directive('tmNewTaskForm', tmNewTaskForm)
)()
