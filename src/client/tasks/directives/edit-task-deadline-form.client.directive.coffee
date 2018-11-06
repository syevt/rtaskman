(->
  tmEditTaskDeadlineForm = ()->
    restrict: 'E'
    replace: on
    templateUrl: 'tasks/directives/templates/\
      edit-task-deadline-form.client.template.html'

  require('angular')
    .module('tasks')
    .directive('tmEditTaskDeadlineForm', tmEditTaskDeadlineForm)
)()
