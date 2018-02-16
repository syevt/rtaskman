(->
  tmTaskDraggable = (taskDragger)->
    restrict: 'A'
    scope: on
    link: (scope, element, attrs)->
      el = element[0]
      el.draggable = on
      el.addEventListener(
        'dragstart', taskDragger.dragstart(scope.project, scope.task), off
      )

  tmTaskDraggable.$inject = ['taskDragger']

  require('angular')
    .module('tasks')
    .directive('tmTaskDraggable', tmTaskDraggable)
)()
