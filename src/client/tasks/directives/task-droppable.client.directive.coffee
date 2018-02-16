(->
  tmTaskDroppable = (taskDragger)->
    restrict: 'A'
    scope: on
    link: (scope, element, attrs)->
      el = element[0]
      el.draggable = on
      # task = scope.task
      # project = scope.project
      for event in ['dragenter', 'dragover', 'dragleave', 'drop']
        el.addEventListener(
          event, taskDragger[event](scope.project, scope.task), off
        )
      # el.addEventListener('dragenter', taskDragger.enter(project, task), off)
      # el.addEventListener('dragover', taskDragger.over(project, task), off)
      # el.addEventListener('dragleave', taskDragger.leave(project, task), off)
      # el.addEventListener('drop', taskDragger.drop(project, task), off)

  tmTaskDroppable.$inject = ['taskDragger']

  require('angular')
    .module('tasks')
    .directive('tmTaskDroppable', tmTaskDroppable)
)()
