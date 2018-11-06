describe 'tmTaskDraggable directive', ()->
  scope = {}
  el = angular.element('<div tm-task-draggable></div>')
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

  it 'sets el draggable attribute to true', ()->
    expect(el[0].draggable).to.be.true

  it "adds 'dragstart' event listener on element", ()->
    expect(spy).to.have.been.calledWith('dragstart')
