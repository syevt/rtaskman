(->
  tmSaveCancelButtons = ()->
    restrict: 'E'
    replace: on
    templateUrl: 'tasks/directives/templates/\
      save-cancel-buttons.client.template.html'

  require('angular')
    .module('tasks')
    .directive('tmSaveCancelButtons', tmSaveCancelButtons)
)()
