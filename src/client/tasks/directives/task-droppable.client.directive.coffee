(->
  tmTaskDroppable = (taskDragger)->
    restrict: 'A'
    link: (scope, element, attrs)->
      el = element[0]
      el.draggable = on
      el.addEventListener('dragenter', taskDragger.dragEnter, off)
      el.addEventListener('dragover', taskDragger.dragOver, off)
      el.addEventListener('dragleave', taskDragger.dragLeave, off)
      el.addEventListener('drop', taskDragger.drop, off)

  tmTaskDroppable.$inject = ['taskDragger']

  require('angular')
    .module('tasks')
    .directive('tmTaskDroppable', tmTaskDroppable)
)()
