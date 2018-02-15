(->
  taskDraggerHelper = ()->
    getIds = (el)->
      el.id.split('-tm_ids-')

    return
      isValidTarget: (el)->
        ids = getIds(el)
        targetProjectId = ids[0]
        sourceProjectId = sessionStorage.getItem('projectId')
        targetId = ids[1]
        sourceId = sessionStorage.getItem('id')
        targetProjectId is sourceProjectId and targetId isnt sourceId

      offsets: (el, clickX)->
        elBox = el.getBoundingClientRect()
        [clickX - elBox.left, elBox.height / 2]

      setSourceData: (el)->
        ids = getIds(el)
        sessionStorage.setItem('projectId', ids[0])
        sessionStorage.setItem('id', ids[1])
        sessionStorage.setItem('priority', el.dataset.priority)

      sourceElement: (el)->
        document.getElementById(el.getAttribute('tm-task-draggable'))

  require('angular')
    .module('tasks')
    .factory('taskDraggerHelper', taskDraggerHelper)
)()
