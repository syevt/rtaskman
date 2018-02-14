(->
  taskDraggerHelper = ()->
    sourceElement: (el)->
      document.getElementById(el.getAttribute('tm-task-draggable'))

    setSourceData: (el, event)->
      ids = el.id.split('-tm_ids-')
      event.dataTransfer.setData('projectId', ids[0])
      event.dataTransfer.setData('id', ids[1])
      event.dataTransfer.setData('priority', el.dataset.priority)

    offsets: (el, clickX)->
      elBox = el.getBoundingClientRect()
      [clickX - elBox.left, elBox.height / 2]

    getSpacerElement: (el, event)->
      sourcePriority = parseInt(event.dataTransfer.getData('sourcePriority'))
      targetPriority = parseInt(el.dataset.priority)
      direction = if sourcePriority > targetPriority then 'below' else 'above'
      document.getElementById("#{direction}-#{ids[0]}-#{ids[1]}")

    sourceTask: (el, event)->
      priority: parseInt(event.dataTransfer.getData('sourcePriority'))

  require('angular')
    .module('tasks')
    .factory('taskDraggerHelper', taskDraggerHelper)
)()
