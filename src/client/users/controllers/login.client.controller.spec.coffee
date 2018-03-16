describe 'LoginController', ()->
  controller = {}

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$controller', '$q', '$rootScope', '$location', '$uibModal',
    '$httpBackend', '$auth', 'Identity', 'growl', '$translate')
    controller = $controller('LoginController', $scope: $rootScope.$new)

  context 'showSignupModal()', ()->
    it 'clears @email, @password and @confirmPassword', ()->
      controller.showSignupModal()
      for field in ['email', 'password', 'confirmPassword']
        expect(controller[field]).to.be.empty

    it 'opens signup modal', ()->
      sinon.spy($uibModal, 'open')
      controller.showSignupModal()
      expect($uibModal.open).to.have.been.called

  context 'signin()', ()->
    context 'with success', ()->
      it 'assigns returned user to @identity.user', ()->
        email = 'some@email.ua'
        sinon.stub($auth, 'submitLogin').returns($q.when(email: email))
        controller.signin()
        $rootScope.$apply()
        expect(controller.identity.user.email).to.eq(email)

      it 'makes growl to show success message', ()->

      it 'routes to user`s projects view', ()->

    context 'with error', ()->
      it 'makes growl to show error message', ()->
        error = 'login error'
        sinon.spy(growl, 'error')
        sinon.stub($auth, 'submitLogin').returns($q.reject(errors: [error]))
        controller.signin()
        $rootScope.$apply()
        expect(growl.error).to.have.been.calledWith(error)
