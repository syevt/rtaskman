(->
  taskDraggerHelper = ()->
    isValidTarget: (project, task)->
      sourceProjectId = parseInt(sessionStorage.getItem('projectId'))
      sourceId = parseInt(sessionStorage.getItem('id'))
      project.id is sourceProjectId and task.id isnt sourceId

    offsets: (el, clickX)->
      elBox = el.getBoundingClientRect()
      [clickX - elBox.left, elBox.height / 2]

    setSourceData: (project, task)->
      sessionStorage.setItem('projectId', project.id)
      sessionStorage.setItem('id', task.id)
      sessionStorage.setItem('priority', task.priority)

    sourceElement: (project, task)->
      document.getElementById("task-#{project.id}-#{task.id}")

  require('angular')
    .module('tasks')
    .factory('taskDraggerHelper', taskDraggerHelper)
)()
