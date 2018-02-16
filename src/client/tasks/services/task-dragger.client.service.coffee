(->
  taskDragger = (taskDraggerHelper)->
    clearDragClasses = (el)->
      for item in ['below', 'above']
        el.classList.remove("tm-task-row-dragover-#{item}")

    return
      dragstart: (project, task)->
        (e)->
          e.stopPropagation() if e.stopPropagation
          e.dataTransfer.effectAllowed = "move"
          sourceElement = taskDraggerHelper.sourceElement(project, task)
          taskDraggerHelper.setSourceData(project, task)
          offsets = taskDraggerHelper.offsets(sourceElement, e.clientX)
          e.dataTransfer.setDragImage(sourceElement, offsets...)
          # return

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
          # console.log 'dropped...'
          console.log e
          console.log project
        # access to ctrlScope.parentProject
        # access to source task id and priority - got one in sessionStorage
        # access to target task priority - got 'em in sessionStorage
        # need to inject Task resource
        # 1. new resourse with id, priority, targetPriority
        # 2. in server ctrl new update branch if params.targetPriority present
        # 3. reassign priorities for ALL task.parentProject.tasks
        # 4. on success in promise reassign ALL priorities in client parentProject
        # scope: {
          # myindex: '='
        # },
        # link: function(scope, element, attrs){
          # console.log('test', scope.myindex)

  taskDragger.$inject = ['taskDraggerHelper']

  require('angular').module('tasks').factory('taskDragger', taskDragger)
)()
