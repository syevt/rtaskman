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

    reorderTasks: (tasks, target, sourcePriority)->
      from = tasks.findIndex (task)-> task.priority is sourcePriority
      to = tasks.findIndex (task)-> task.priority is target.priority
      tasks.splice(to, 0, tasks.splice(from, 1)[0])

  require('angular')
    .module('tasks')
    .factory('taskDraggerHelper', taskDraggerHelper)
)()
