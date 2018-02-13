(->
  taskDraggerHelper = ()->
    getOffsets: (el, clickX)->
      elBox = el.getBoundingClientRect()
      [clickX - elBox.left, elBox.height / 2]

    getSpacerElement: (el, event)->
      sourcePriority = parseInt(event.dataTransfer.getData('sourcePriority'))
      targetPriority = parseInt(el.dataset.priority)
      ids = el.id.split('-tm_ids-')
      direction = if sourcePriority > targetPriority then 'below' else 'above'
      document.getElementById("#{direction}-#{ids[0]}-#{ids[1]}")

  require('angular')
    .module('tasks')
    .factory('taskDraggerHelper', taskDraggerHelper)
)()
