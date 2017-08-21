angular = require 'angular'
angular.module('projects')
.directive 'tmTaskDroppable', ['growl', (growl) ->
  (scope, element, attrs) ->
    el = element[0]
    el.addEventListener 'dragenter',
      (e) ->
        @classList.add 'tm-task-row-dragover'
        off
      , off
    el.addEventListener 'dragover',
      (e) ->
        e.dataTransfer.dropEffect = "move"
        e.preventDefault() if e.preventDefault
        @classList.add 'tm-task-row-dragover'
        off
      , off
    el.addEventListener 'dragleave',
      (e) ->
        @classList.remove 'tm-task-row-dragover'
        off
      , off
    el.addEventListener 'drop',
      (e) ->
        e.stopPropagation() if e.stopPropagation
        @classList.remove 'tm-task-row-dragover'
        sourceIDs = e.dataTransfer.getData('taskId').split '-#%&-'
        sourceProjectId = sourceIDs[0]
        sourceTaskIndex = sourceIDs[1]
        targetIDs = el.id.split('-#%&-')
        targetProjectId = targetIDs[0]
        targetTaskIndex = targetIDs[1]
        if sourceProjectId is targetProjectId
          if sourceTaskIndex isnt targetTaskIndex
            scope.$apply () ->
              scope.project.tasks.splice targetTaskIndex, 0, (scope.project.tasks.splice(sourceTaskIndex, 1)[0])
            scope.update scope.project
        else
          growl.warning 'Changing priority is only allowed for the same project'
]