require('angular').module('users').controller 'LoginController',
  ['$scope', '$location', '$routeParams', '$uibModal', '$auth', 'Identity', 'Authentication', 'growl',
    ($scope, $location, $routeParams, $uibModal, $auth, Identity, Authentication, growl) ->
      $scope.identity = Identity

      $scope.signin = ->
        $auth.submitLogin(email: @email, password: @password).then (user) ->
          $scope.identity.user = user
          growl.success 'Successfully logged in!'
          $location.path "/users/#{$scope.identity.user.id}/projects"
        , (errorResponse) ->
            growl.error errorResponse.errors[0]

      $scope.showUserProjects = () ->
        $location.path "/users/#{$scope.identity.user.id}/projects"

      $scope.signout = () ->
        $auth.signOut().then () ->
          $scope.email = null
          $scope.password = null
          $scope.identity.user = null
          growl.success 'You have logged out!'
          $location.path '/'

      $scope.showSignupModal = () ->
        @email = ""
        @password = ""
        modalInstance = $uibModal.open
          templateUrl: 'users/views/signup-modal.client.view.html'
          controller: 'SignupController'
          scope: $scope
          resolve:
            userForm: () ->
              return $scope.userForm
  ]
