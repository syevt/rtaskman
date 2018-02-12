(->
  moment = require 'moment'

  tmDateFormatter = ()->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, ngModelController)->
      ngModelController.$parsers.push (data)->
        moment.utc(data).toDate()

      ngModelController.$formatters.push (data)->
        moment.utc(data).toDate()

  require('angular')
    .module('common')
    .directive('tmDateFormatter', tmDateFormatter)
)()
