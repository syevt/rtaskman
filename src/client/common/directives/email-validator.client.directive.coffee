(->
  tmEmailValidator = ()->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, el, attrs, ctrl)->
      ctrl.$validators.emailValidator = (modelValue, viewValue)->
        emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/i
        return on if ctrl.$isEmpty(modelValue)
        return on if emailRegex.test(viewValue)
        return off

  require('angular')
    .module('common')
    .directive('tmEmailValidator', tmEmailValidator)
)()
