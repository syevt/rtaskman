(->
  tmTaskButtons = ()->
    restrict: 'E'
    replace: on
    templateUrl: 'tasks/directives/templates/\
      task-buttons.client.template.html'

  require('angular').module('tasks').directive('tmTaskButtons', tmTaskButtons)
)()
