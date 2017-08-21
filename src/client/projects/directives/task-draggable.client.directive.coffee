angular = require 'angular'
angular.module('projects')
.directive 'tmTaskDraggable', () ->
  (scope, element, attrs) ->
    el = element[0]
    el.draggable = on
    el.addEventListener 'dragstart',
      (e) ->
        e.stopPropagation() if e.stopPropagation
        e.dataTransfer.effectAllowed = "move"
        id = attrs.tmTaskDraggable
        sourceTask = document.getElementById id
        sourceTaskBox = sourceTask.getBoundingClientRect()
        offsetX = e.screenX - sourceTaskBox.left
        offsetY = sourceTaskBox.height / 2
        e.dataTransfer.setData 'taskId', id
        e.dataTransfer.setDragImage sourceTask, offsetX, offsetY
        off
      , off