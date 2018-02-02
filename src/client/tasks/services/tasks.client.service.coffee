(->
  tasks = ($resource)->
    return $resource 'api/v1/tasks/:taskId',
      taskId: '@id'
    ,
      update:
        method: 'PUT'

  tasks.$inject = ['$resource']

  require('angular').module('tasks').factory('TasksService', tasks)
)()
