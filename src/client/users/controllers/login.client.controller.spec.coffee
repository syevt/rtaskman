describe 'LoginController', ()->
  controller = {}
  cred_fields = ['email', 'password', 'confirmPassword']
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$controller', '$q', '$rootScope', '$location', '$uibModal',
                '$auth', 'growl', '$translate')
    controller = $controller('LoginController')

  afterEach ()->
    sandbox.restore()

  context '#showSignupModal', ()->
    it 'clears @email, @password and @confirmPassword', ()->
      controller.showSignupModal()
      for field in cred_fields
        expect(controller[field]).to.be.empty

    it 'opens signup modal', ()->
      sinon.spy($uibModal, 'open')
      controller.showSignupModal()
      expect($uibModal.open).to.have.been.called

  context 'signing in and out', ()->
    beforeEach ()->
      sandbox.spy(growl, 'success')
      sandbox.spy($translate, 'instant')
      sandbox.spy($location, 'path')

    context '#signin', ()->
      context 'with successful response', ()->
        email = 'some@email.ua'

        beforeEach ()->
          sinon.stub($auth, 'submitLogin').returns($q.when(email: email))
          controller.signin()
          $rootScope.$apply()

        it 'assigns returned user to @identity.user', ()->
          expect(controller.identity.user.email).to.eq(email)

        it 'makes growl to show success message', ()->
          expect($translate.instant).to.have.been.calledWith('auth.loggedIn')
          expect(growl.success).to.have.been.called

        it 'routes to user`s projects view', ()->
          expect($location.path).to.have.been.calledWith('/projects')

      context 'with error response', ()->
        it 'makes growl to show error message', ()->
          error = 'login error'
          sandbox.spy(growl, 'error')
          sinon.stub($auth, 'submitLogin').returns($q.reject(errors: [error]))
          controller.signin()
          $rootScope.$apply()
          expect(growl.error).to.have.been.calledWith(error)

    context '#signout', ()->
      beforeEach ()->
        sinon.stub($auth, 'signOut').returns($q.when())
        controller.signout()
        $rootScope.$apply()

      it 'nullifies @email, @password and @confirmPassword', ()->
        for field in cred_fields
          expect(controller[field]).to.be.null

      it 'nullifies @identity.user', ()->
        expect(controller.identity.user).to.be.null

      it 'makes growl show successful signout message', ()->
        expect($translate.instant).to.have.been.calledWith('auth.loggedOut')
        expect(growl.success).to.have.been.called

      it "routes to '/'", ()->
        expect($location.path).to.have.been.calledWith('/')
