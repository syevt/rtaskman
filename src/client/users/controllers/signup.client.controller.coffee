require('angular').module('users').controller 'SignupController',
  ['$scope', '$routeParams', '$location', 'Users', 'Identity',
    'growl', '$uibModalInstance', 'userForm',
    ($scope, $routeParams, $location, Users, Identity, growl, $uibModalInstance, userForm) ->

      $scope.form = {}

      $scope.create = () ->
        return if $scope.userForm.$invalid

        user = new Users
          firstName: @firstName
          lastName: @lastName
          userName: @userName
          password: @password
          confirmPassword: @confirmPassword

        user.$save (response) ->
          Identity.user = user
          growl.success 'User has been successfully created'
          $uibModalInstance.close()
          # $location.path '/'
          $location.path "/users/#{$scope.identity.user._id}/projects"
        , (errorResponse) ->
            $scope.error = errorResponse

      $scope.cancel = () ->
        $uibModalInstance.dismiss()
        # $location.path '/'
  ]