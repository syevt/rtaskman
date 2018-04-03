describe 'removalModal', ()->
  context '#open', ()->
    it 'calls open() on $uibModal', ()->
      bard.appModule('taskManager')
      bard.inject('removalModal', '$uibModal')
      modalOpen = sinon.spy($uibModal, 'open')
      removalModal.open()
      expect(modalOpen).to.have.been.called
      modalOpen.restore()
