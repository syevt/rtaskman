angular = require 'angular'

angular.module('taskManager')
  .directive 'confirmPassword', () ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, el, attrs, ctrl) ->

      ctrl.$validators.confirmPassword = (modelValue, viewValue) ->

        if ctrl.$isEmpty modelValue
          return on

        if modelValue is scope.userForm.password.$modelValue
          return on

        return off