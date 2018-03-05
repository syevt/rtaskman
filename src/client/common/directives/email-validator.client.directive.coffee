(->
  tmEmailValidator = ()->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, el, attrs, ctrl)->
      ctrl.$validators.emailValidator = (modelValue, viewValue)->
        email_regex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/i
        return on if email_regex.test(viewValue)
        return off

  require('angular')
    .module('common')
    .directive('tmEmailValidator', tmEmailValidator)
)()
