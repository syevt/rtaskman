(->
  taskDragger = (taskDraggerHelper)->
    dragStart: (e)->
      e.stopPropagation() if e.stopPropagation
      e.dataTransfer.effectAllowed = "move"
      id = @getAttribute('tm-task-draggable')
      sourceTask = document.getElementById(id)
      e.dataTransfer.setData('sourcePriority', @dataset.priority)
      e.dataTransfer.setDragImage(
        sourceTask, taskDraggerHelper.getOffsets(sourceTask, e.clientX)...)
      off

    dragEnter: (e)->
      @classList.add('tm-task-row-dragover')
      taskDraggerHelper.getSpacerElement(@, e).hidden = off

    dragOver: (e)->
      e.dataTransfer.dropEffect = 'move'
      e.preventDefault() if e.preventDefault

    dragLeave: (e)->
      @classList.remove('tm-task-row-dragover')
      taskDraggerHelper.getSpacerElement(@, e).hidden = on

    drop: (e)->
      @classList.remove('tm-task-row-dragover')
      taskDraggerHelper.getSpacerElement(@, e).hidden = on

  taskDragger.$inject = ['taskDraggerHelper']

  require('angular').module('tasks').factory('taskDragger', taskDragger)
)()
