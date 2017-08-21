require('angular').module('users').controller 'LoginController',
  ['$scope', '$location', '$routeParams', '$uibModal', 'Identity', 'Authentication', 'growl',
    ($scope, $location, $routeParams, $uibModal, Identity, Authentication, growl) ->
      $scope.identity = Identity

      $scope.signin = (username, password) ->
        Authentication.authenticateUser(username, password).then (success) ->
          if success
            growl.success 'Successfully logged in!'
            $location.path "/users/#{$scope.identity.user._id}/projects"
          else
            growl.error 'Wrong username or password!'

      $scope.showUserProjects = () ->
        $location.path "/users/#{$scope.identity.user._id}/projects"

      $scope.signout = () ->
        Authentication.logoutUser().then () ->
          growl.success 'You have logged out!'
          $scope.username = ""
          $scope.password = ""
          $location.path '/'

      $scope.showSignupModal = () ->
        @username = ""
        @password = ""
        modalInstance = $uibModal.open
          templateUrl: 'users/views/signup-modal.client.view.html'
          controller: 'SignupController'
          scope: $scope
          resolve:
            userForm: () ->
              return $scope.userForm

        # modalInstance.result.then () ->
        #   console.log 'success form'
        # , () ->
        #   console.log 'cancel form'
  ]