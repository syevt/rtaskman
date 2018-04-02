(->
  moment = require 'moment'

  tmDateFormatter = ()->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, ngModelController)->
      ngModelController.$formatters.push (data)->
        moment.utc(data).toDate()

  require('angular')
    .module('common')
    .directive('tmDateFormatter', tmDateFormatter)
)()
