(->
  taskDragger = (taskDraggerHelper)->
    clearDragClasses = (el)->
      for item in ['below', 'above']
        el.classList.remove("tm-task-row-dragover-#{item}")

    return
      dragStart: (e)->
        e.stopPropagation() if e.stopPropagation
        e.dataTransfer.effectAllowed = "move"
        sourceElement = taskDraggerHelper.sourceElement(@)
        taskDraggerHelper.setSourceData(sourceElement)
        e.dataTransfer.setDragImage(
          sourceElement, taskDraggerHelper.offsets(sourceElement, e.clientX)...)
        off

      dragEnter: (e)->
        return unless taskDraggerHelper.isValidTarget(@)
        targetPriority = parseInt(@dataset.priority)
        sourcePriority = parseInt(sessionStorage.getItem('priority'))
        direction = if sourcePriority < targetPriority then 'below' else 'above'
        @classList.add("tm-task-row-dragover-#{direction}")

      dragOver: (e)->
        return unless taskDraggerHelper.isValidTarget(@)
        e.dataTransfer.dropEffect = 'move'
        e.preventDefault() if e.preventDefault

      dragLeave: (e)->
        return unless taskDraggerHelper.isValidTarget(@)
        clearDragClasses(@)

      drop: (e)->
        return unless taskDraggerHelper.isValidTarget(@)
        clearDragClasses(@)
        console.log 'dropped...'
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
