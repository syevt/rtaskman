(->
  tmEditTaskContentForm = ()->
    restrict: 'E'
    replace: on
    templateUrl: 'tasks/directives/templates/\
      edit-task-content-form.client.template.html'

  require('angular')
    .module('tasks')
    .directive('tmEditTaskContentForm', tmEditTaskContentForm)
)()
