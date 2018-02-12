(->
  angular = require 'angular'
  moment = require 'moment'

  Tasks = (Task, RemoveModal, growl)->
    init = ()=>
      @cancelEdit = cancelEdit
      @create = create
      @deadlineTip = deadlineTip
      @edit = edit
      @remove = remove
      @showBell = showBell
      @toggleStatus = toggleStatus
      @update = update

    cancelEdit = ()=>
      @currentTask = null
      @editingProperty = ''

    create = ()=>
      task = new Task
        project_id: @parentProject.id
        content: @parentProject.newTask.content
        priority: @parentProject.tasks.length

      task.$save().then (response)=>
        @parentProject.tasks.push(response)
        @parentProject.newTask = null
      , (errorResponse)->
        growl.error(errorResponse.data.errors[0], ttl: -1)

    deadlineTip = (deadline)->
      return 'Set deadline' unless deadline
      'Edit deadline: ' + moment.utc(deadline).format('LL')

    edit = (task, property)=>
      @backedupTask = angular.extend({}, task)
      @currentTask = angular.extend({}, task)
      @editingProperty = property

    remove = (task, taskIndex)->
      options = entity: 'task', caption: task.content
      task = new Task(task)
      RemoveModal.open(options).result.then ()=>
        task.$remove().then ()=>
          @parentProject.tasks.splice(taskIndex, 1)
        , (errorResponse)->
          growl.error(errorResponse.data.errors[0], ttl: -1)

    showBell = (task)->
      !!task.deadline && !task.done &&
        moment.utc(task.deadline).add(1, 'd') < moment.utc()

    toggleStatus = (task)->
      edit(task, '')
      update(task)

    update = (task)=>
      taskBeingEdited = new Task(@currentTask)
      taskBeingEdited.$update().then (response)=>
        angular.extend task, response
        @currentTask = null
      , (errorResponse)=>
        angular.extend(@currentTask, @backedupTask)
        growl.error(errorResponse.data.errors[0], ttl: -1)

    init()
    return

  Tasks.$inject = ['Task', 'RemoveModal', 'growl']

  angular.module('tasks').controller('Tasks', Tasks)
)()
