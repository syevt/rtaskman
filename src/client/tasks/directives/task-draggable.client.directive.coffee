(->
  tmTaskDraggable = (taskDragger)->
    restrict: 'A'
    link: (scope, element, attrs)->
      el = element[0]
      el.draggable = on
      el.addEventListener('dragstart', taskDragger.dragStart, off)

  tmTaskDraggable.$inject = ['taskDragger']

  require('angular')
    .module('tasks')
    .directive('tmTaskDraggable', tmTaskDraggable)
)()
