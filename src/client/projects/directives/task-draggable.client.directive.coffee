angular = require 'angular'
angular.module('projects')
.directive 'tmTaskDraggable', () ->
  (scope, element, attrs) ->
    el = element[0]
    el.draggable = on
    el.addEventListener 'dragstart',
      (e) ->
        # console.log e
        e.stopPropagation() if e.stopPropagation
        e.dataTransfer.effectAllowed = "move"
        id = attrs.tmTaskDraggable
        sourceTask = document.getElementById id
        sourceTaskBox = sourceTask.getBoundingClientRect()
        # console.log sourceTaskBox
        offsetX = e.clientX - sourceTaskBox.left
        offsetY = sourceTaskBox.height / 2
        e.dataTransfer.setData 'taskId', id
        sourceTask.classList.add('tm-task-row-dragstart')
        e.dataTransfer.setDragImage sourceTask, offsetX, offsetY
        # e.dataTransfer.setDragImage sourceTask, 20, 30
        off
      , off
