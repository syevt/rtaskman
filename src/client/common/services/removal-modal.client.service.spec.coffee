describe.only 'removalModal', ()->
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('removalModal', '$uibModal')

  afterEach ()->
    sandbox.restore()

  context '#open', ()->
    it 'calls open() on $uibModal', ()->
      sandbox.spy($uibModal, 'open')
      removalModal.open()
      expect($uibModal.open).to.have.been.called
