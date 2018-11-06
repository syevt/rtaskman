(->
  tmTasksTable = ()->
    restrict: 'E'
    replace: on
    templateUrl: 'tasks/directives/templates/\
      tasks-table.client.template.html'

  require('angular').module('tasks').directive('tmTasksTable', tmTasksTable)
)()
