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

    reorderTasks: (tasks, targetPriority, sourcePriority)->
      from = tasks.findIndex (task)-> task.priority is sourcePriority
      to = tasks.findIndex (task)-> task.priority is targetPriority
      source = (task for task in tasks when task.priority is sourcePriority)[0]
      source.priority = targetPriority
      if from < to
        task.priority -= 1 for task in tasks[(from + 1)..to]
      else
        task.priority += 1 for task in tasks[to...from]
      tasks.sort (current, next)-> current.priority - next.priority

  require('angular')
    .module('tasks')
    .factory('taskDraggerHelper', taskDraggerHelper)
)()
