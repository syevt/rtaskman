describe 'SignupController', ()->
  controller = {}
  $uibModalInstance = dismiss: (->), close: (->)
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$controller', '$q', '$rootScope', '$location',
                '$auth', 'growl', '$translate')
    scope = $rootScope.$new()
    controller = $controller 'SignupController',
                             # $scope: $rootScope.$new,
                             $scope: scope,
                             $uibModalInstance: $uibModalInstance
    scope.$digest()

  afterEach ()->
    sandbox.restore()

  context '#cancel', ()->
    it 'closes signup modal', ()->
      sandbox.spy($uibModalInstance, 'dismiss')
      controller.cancel()
      expect($uibModalInstance.dismiss).to.have.been.called

  context '#create', ()->
    context 'with invalid registration data', ()->
      it 'doesn`t submit invalid registration data', ()->
        sandbox.stub(controller.$scope.userForm, '$invalid').returns(on)
        sandbox.spy($auth, 'submitRegistration')
        controller.create()
        expect($auth.submitRegistration).to.not.have.been.called

    context 'with valid registration data', ()->
      context 'with successful response', ()->
        it 'submits controller registration data'
        it 'assigns returned user to Identity service field'
        it 'shows growl signup successful message'
        it 'closes signup modal'
        it 'routes to user`s projects view'
      context 'with error response', ()->
        it 'closes signup modal'
        it 'shows registration error message'
