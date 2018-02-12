(->
  taskDragger = ()->
    dragStart: (e)->
      e.stopPropagation() if e.stopPropagation
      e.dataTransfer.effectAllowed = "move"
      id = e.target.getAttribute('tm-task-draggable')
      sourceTask = document.getElementById(id)
      sourceTaskBox = sourceTask.getBoundingClientRect()
      offsetX = e.clientX - sourceTaskBox.left
      offsetY = sourceTaskBox.height / 2
      e.dataTransfer.setData('taskId', id)
      e.dataTransfer.setDragImage(sourceTask, offsetX, offsetY)
      off

  require('angular').module('tasks').factory('taskDragger', taskDragger)
)()
