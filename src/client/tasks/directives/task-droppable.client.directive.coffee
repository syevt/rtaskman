(->
  tmTaskDroppable = (taskDragger)->
    restrict: 'A'
    scope: on
    link: (scope, element, attrs)->
      el = element[0]
      for event in ['dragenter', 'dragover', 'dragleave', 'drop']
        el.addEventListener(
          event, taskDragger[event](scope.project, scope.task), off
        )

  tmTaskDroppable.$inject = ['taskDragger']

  require('angular')
    .module('tasks')
    .directive('tmTaskDroppable', tmTaskDroppable)
)()
