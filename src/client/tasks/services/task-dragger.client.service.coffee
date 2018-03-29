(->
  taskDragger = (taskDraggerHelper, Task, growl)->
    clearDragClasses = (el)->
      for item in ['below', 'above']
        el.classList.remove("tm-task-row-dragover-#{item}")

    getSourcePriority = ()->
      parseInt(sessionStorage.getItem('priority'))

    return
      dragstart: (project, task)->
        (e)->
          e.stopPropagation() if e.stopPropagation
          e.dataTransfer.effectAllowed = 'move'
          e.dataTransfer.setData('text/html', 'otherwise mozilla goes crazy!!!')
          sourceElement = taskDraggerHelper.sourceElement(project, task)
          taskDraggerHelper.setSourceData(project, task)
          offsets = taskDraggerHelper.offsets(sourceElement, e.clientX)
          e.dataTransfer.setDragImage(sourceElement, offsets...)

      dragenter: (project, task)->
        (e)->
          return unless taskDraggerHelper.isValidTarget(project, task)
          sourcePriority = getSourcePriority()
          direction = if sourcePriority < task.priority then 'below' else 'above'
          e.currentTarget.classList.add("tm-task-row-dragover-#{direction}")

      dragover: (project, task)->
        (e)->
          return unless taskDraggerHelper.isValidTarget(project, task)
          e.dataTransfer.dropEffect = 'move'
          e.preventDefault() if e.preventDefault

      dragleave: (project, task)->
        (e)->
          return unless taskDraggerHelper.isValidTarget(project, task)
          clearDragClasses(e.currentTarget)

      drop: (project, task)->
        (e)->
          return unless taskDraggerHelper.isValidTarget(project, task)
          clearDragClasses(e.currentTarget)
          sourcePriority = getSourcePriority()
          currentTask = new Task
            id: task.id
            priority: task.priority
            sourcepriority: sourcePriority
          currentTask.$update().then ()->
            taskDraggerHelper.reorderTasks(
              project.tasks, task.priority, sourcePriority)
          , (errorResponse)->
            growl.error(errorResponse.data.errors[0], ttl: -1)

  taskDragger.$inject = ['taskDraggerHelper', 'Task', 'growl']

  require('angular').module('tasks').factory('taskDragger', taskDragger)
)()
