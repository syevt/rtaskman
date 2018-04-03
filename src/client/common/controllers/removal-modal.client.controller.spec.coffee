describe 'RemovalModalCtrl', ()->
  controller = {}
  sandbox = sinon.createSandbox()
  $uibModalInstance = close: (()->), dismiss: (()->)

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$controller')
    controller = $controller 'RemovalModalCtrl',
      $uibModalInstance: $uibModalInstance
      entity: 'foo'
      caption: 'bar'

  afterEach ()->
    sandbox.restore()

  context 'local variables', ()->
    it 'assigns passed values to @entity and @caption', ()->
      expect(controller.entity).to.eq('foo')
      expect(controller.caption).to.eq('bar')

  context '#ok', ()->
    it 'calls close() on modal', ()->
      closeSpy = sandbox.spy($uibModalInstance, 'close')
      controller.ok()
      expect(closeSpy).to.have.been.called

  context '#cancel', ()->
    it 'calls dismiss() on modal', ()->
      dismissSpy = sandbox.spy($uibModalInstance, 'dismiss')
      controller.cancel()
      expect(dismissSpy).to.have.been.called
