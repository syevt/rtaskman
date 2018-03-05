(->
  tmConfirmPassword = ()->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, el, attrs, ctrl) ->
      ctrl.$validators.confirmPassword = (modelValue, viewValue) ->
        return on if ctrl.$isEmpty(modelValue)
        return on if modelValue is scope.userForm.password.$modelValue
        return off

  require('angular')
    .module('common')
    .directive('tmConfirmPassword', tmConfirmPassword)
)()
