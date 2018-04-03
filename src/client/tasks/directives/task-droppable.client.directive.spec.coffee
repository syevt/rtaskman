describe 'tmTaskDroppable directive', ()->
  scope = {}
  el = angular.element('<div tm-task-droppable></div>')
  spy = {}
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$rootScope', '$compile')
    spy = sandbox.spy(el[0], 'addEventListener')
    scope = $rootScope.$new()
    $compile(el)(scope)

  afterEach ()->
    sandbox.restore()

  for event in ['dragenter', 'dragover', 'dragleave', 'drop']
    do (event)->
      it "adds '#{event}' event listener on element", ()->
        expect(spy).to.have.been.calledWith(event)
