require('angular').module('users').controller 'SignupController',
  ['$scope', '$routeParams', '$location', 'Identity',
    'growl', '$uibModalInstance', '$auth',
    ($scope, $routeParams, $location, Identity, growl, $uibModalInstance, $auth) ->

      $scope.form = {}

      $scope.create = () ->
        return if $scope.userForm.$invalid

        $auth.submitRegistration(
          email: @email
          password: @password
          password_confirmation: @confirmPassword
          ).then (res) ->
            Identity.user = res.data.data
            growl.success 'User has been successfully created'
            $uibModalInstance.close()
            $location.path "/users/#{$scope.identity.user.id}/projects"
         , (errorResponse) ->
           $uibModalInstance.close()
           growl.error errorResponse.data.errors.full_messages[0], ttl: 10000

      $scope.cancel = () ->
        $uibModalInstance.dismiss()
  ]
