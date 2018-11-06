(->
  angular = require('angular')

  SignupController = ($location, $uibModalInstance, $auth, Identity,
  growl, $translate)->
    init = ()=>
      @cancel = ()-> $uibModalInstance.dismiss()
      @create = create

    create = ()=>
      return if @userForm.$invalid
      $auth.submitRegistration(
        email: @email
        password: @password
        password_confirmation: @confirmPassword
        ).then (response)->
          Identity.user = angular.extend(response.data.data, signedIn: on)
          growl.success($translate.instant('auth.signedUp'))
          $uibModalInstance.close()
          $location.path('/projects')
       , (errorResponse)->
         $uibModalInstance.close()
         growl.error(errorResponse.data.errors.full_messages[0], ttl: -1)

    init()
    return

  SignupController.$inject = ['$location', '$uibModalInstance', '$auth',
                              'Identity', 'growl', '$translate']

  angular.module('users').controller('SignupController', SignupController)
)()
