(->
  Task = ($resource)->
    return $resource 'api/v1/tasks/:taskId',
      taskId: '@id'
    ,
      update:
        method: 'PUT'

  Task.$inject = ['$resource']

  require('angular').module('tasks').factory('Task', Task)
)()
