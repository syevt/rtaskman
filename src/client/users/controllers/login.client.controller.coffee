(->
  LoginController = ($scope, $location, $uibModal, $auth, Identity,
  growl, $translate)->
    init = ()=>
      @identity = Identity
      @showUserProjects = ()-> $location.path('/projects')
      @showSignupModal = showSignupModal
      @signin = signin
      @signout = signout

    showSignupModal = ()=>
      @email = ''
      @password = ''
      modalInstance = $uibModal.open
        templateUrl: 'users/views/signup-modal.client.view.html'
        controller: 'SignupController'
        scope: $scope
        resolve:
          userForm: ()->
            return $scope.userForm

    signin = ()=>
      $auth.submitLogin(email: @email, password: @password).then (user)=>
        @identity.user = user
        growl.success($translate.instant('auth.loggedIn'))
        $location.path('/projects')
      , (errorResponse)->
          growl.error(errorResponse.errors[0])

    signout = ()=>
      $auth.signOut().then ()=>
        @email = null
        @password = null
        @identity.user = null
        growl.success($translate.instant('auth.loggedOut'))
        $location.path('/')

    init()
    return

  LoginController.$inject = ['$scope', '$location', '$uibModal', '$auth',
                             'Identity',  'growl', '$translate']

  require('angular')
    .module('users')
    .controller('LoginController', LoginController)
)()
