(->
  taskDragger = (taskDraggerHelper, Task)->
    clearDragClasses = (el)->
      for item in ['below', 'above']
        el.classList.remove("tm-task-row-dragover-#{item}")

    return
      dragstart: (project, task)->
        (e)->
          e.stopPropagation() if e.stopPropagation
          e.dataTransfer.effectAllowed = "move"
          e.dataTransfer.setData('text/html', 'otherwise mozilla goes crazy!!!')
          sourceElement = taskDraggerHelper.sourceElement(project, task)
          taskDraggerHelper.setSourceData(project, task)
          offsets = taskDraggerHelper.offsets(sourceElement, e.clientX)
          e.dataTransfer.setDragImage(sourceElement, offsets...)

      dragenter: (project, task)->
        (e)->
          return unless taskDraggerHelper.isValidTarget(project, task)
          sourcePriority = parseInt(sessionStorage.getItem('priority'))
          direction = if sourcePriority < task.priority then 'below' else 'above'
          @classList.add("tm-task-row-dragover-#{direction}")

      dragover: (project, task)->
        (e)->
          return unless taskDraggerHelper.isValidTarget(project, task)
          e.dataTransfer.dropEffect = 'move'
          e.preventDefault() if e.preventDefault

      dragleave: (project, task)->
        (e)->
          return unless taskDraggerHelper.isValidTarget(project, task)
          clearDragClasses(@)

      drop: (project, task)->
        (e)->
          return unless taskDraggerHelper.isValidTarget(project, task)
          clearDragClasses(@)
          taskId = sessionStorage.getItem('id')
          task = new Task
            id: taskId
            priority: parseInt(sessionStorage.getItem('priority'))
            targetpriority: task.priority
          task.$update().then ()-> console.log 'kinda updated...'
        # access to ctrlScope.parentProject
        # access to source task id and priority - got one in sessionStorage
        # access to target task priority - got 'em in sessionStorage
        # need to inject Task resource
        # 1. new resourse with id, priority, targetPriority
        # 2. in server ctrl new update branch if params.targetPriority present
        # 3. reassign priorities for ALL task.parentProject.tasks
        # 4. on success in promise reassign ALL priorities in client parentProject

  taskDragger.$inject = ['taskDraggerHelper', 'Task']

  require('angular').module('tasks').factory('taskDragger', taskDragger)
)()
