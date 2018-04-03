(->
  angular = require 'angular'
  moment = require 'moment'

  Tasks = (Task, removalModal, growl, $translate)->
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

      task.$save().then (response)=>
        @parentProject.tasks.push(response)
        @parentProject.newTask = null
      , (errorResponse)->
        growl.error(errorResponse.data.errors[0], ttl: -1)

    deadlineTip = (deadline)->
      return $translate.instant('tasks.setDeadlineHint') unless deadline
      $translate.instant('tasks.editDeadlineHint') +
        moment.utc(deadline).format('LL')

    edit = (task, property)=>
      @backedupTask = angular.extend({}, task)
      @currentTask = angular.extend({}, task)
      @editingProperty = property

    remove = (task, taskIndex)->
      taskTranslation = $translate.instant('tasks.task')
      task = new Task(task)
      removalModal.open(taskTranslation, task.content).result.then ()=>
        task.$remove().then ()=>
          @parentProject.tasks.splice(taskIndex, 1)
        , (errorResponse)->
          growl.error(errorResponse.data.errors[0], ttl: -1)

    showBell = (task)->
      !!task.deadline && !task.done &&
        moment.utc(task.deadline).add(1, 'd') < moment.utc()

    toggleStatus = (task)=>
      @edit(task, '')
      @update(task)

    update = (task)=>
      new Task(@currentTask).$update().then (response)=>
        angular.extend(task, response)
        @currentTask = null
      , (errorResponse)=>
        angular.extend(@currentTask, @backedupTask)
        growl.error(errorResponse.data.errors[0], ttl: -1)

    init()
    return

  Tasks.$inject = ['Task', 'removalModal', 'growl', '$translate']

  angular.module('tasks').controller('Tasks', Tasks)
)()
