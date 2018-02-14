(->
  taskDragger = (taskDraggerHelper)->
    dragStart: (e)->
      e.stopPropagation() if e.stopPropagation
      e.dataTransfer.effectAllowed = "move"
      sourceElement = taskDraggerHelper.sourceElement(@)
      taskDraggerHelper.setSourceData(sourceElement, e)
      e.dataTransfer.setDragImage(
        sourceElement, taskDraggerHelper.offsets(sourceElement, e.clientX)...)
      off

    dragEnter: (e)->
      @classList.add('tm-task-row-dragover-below')
      # taskDraggerHelper.getSpacerElement(@, e).hidden = off

    dragOver: (e)->
      e.dataTransfer.dropEffect = 'move'
      e.preventDefault() if e.preventDefault

    dragLeave: (e)->
      @classList.remove('tm-task-row-dragover-below')
      # taskDraggerHelper.getSpacerElement(@, e).hidden = on

    drop: (e)->
      @classList.remove('tm-task-row-dragover-below')
      # taskDraggerHelper.getSpacerElement(@, e).hidden = on

  taskDragger.$inject = ['taskDraggerHelper']

  require('angular').module('tasks').factory('taskDragger', taskDragger)
)()
