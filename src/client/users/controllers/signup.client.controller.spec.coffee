describe 'SignupController', ()->
  controller = {}
  $uibModalInstance = close: (()->), dismiss: (()->)
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$controller', '$q', '$rootScope', '$location', 'Identity',
                '$auth', 'growl', '$translate')
    controller = $controller 'SignupController',
                             $uibModalInstance: $uibModalInstance

  afterEach ()->
    sandbox.restore()

  context '#cancel', ()->
    it 'closes signup modal', ()->
      sandbox.spy($uibModalInstance, 'dismiss')
      controller.cancel()
      expect($uibModalInstance.dismiss).to.have.been.called

  context '#create', ()->
    context 'with invalid signup data', ()->
      it 'doesn`t submit invalid signup data', ()->
        controller.userForm = $invalid: on
        sandbox.spy($auth, 'submitRegistration')
        controller.create()
        expect($auth.submitRegistration).to.not.have.been.called

    context 'with valid signup data', ()->
      email = 'some@email.ua'

      beforeEach ()->
        controller.userForm = $invalid: off

      it 'submits controller signup data', ()->
        controller.email = email
        controller.password = 'password'
        controller.confirmPassword = 'password'
        spy = sandbox.spy($auth, 'submitRegistration')
        controller.create()
        expect(spy).to.have.been.calledWithMatch
          email: controller.email
          password: controller.password
          password_confirmation: controller.confirmPassword

      context 'with successful response', ()->
        beforeEach ()->
          sandbox.spy(growl, 'success')
          sandbox.spy($translate, 'instant')
          sandbox.spy($uibModalInstance, 'close')
          sandbox.spy($location, 'path')
          sandbox.stub($auth, 'submitRegistration')
            .returns($q.when(data: {data: {email: email}}))
          controller.create()
          $rootScope.$apply()

        it 'assigns returned user to Identity service field', ()->
          expect(Identity.user.email).to.eq(email)
          expect(Identity.user.signedIn).to.be.true

        it 'makes growl show signup successful message', ()->
          expect(growl.success).to.have.been.called
          expect($translate.instant).to.have.been.calledWith('auth.signedUp')

        it 'closes signup modal', ()->
          expect($uibModalInstance.close).to.have.been.called

        it 'routes to user`s projects view', ()->
          expect($location.path).to.have.been.calledWith('/projects')

      context 'with error response', ()->
        error = 'some error'

        beforeEach ()->
          sandbox.spy(growl, 'error')
          sandbox.spy($uibModalInstance, 'close')
          sandbox.stub($auth, 'submitRegistration')
            .returns($q.reject(data: {errors: {full_messages: [error]}}))
          controller.create()
          $rootScope.$apply()

        it 'closes signup modal', ()->
          expect($uibModalInstance.close).to.have.been.called

        it 'makes growl show signup error message', ()->
          expect(growl.error).to.have.been.calledWith(error)
