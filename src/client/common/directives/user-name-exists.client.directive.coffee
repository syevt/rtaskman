angular = require 'angular'

angular.module('taskManager')
  .directive 'userNameExists', ($q, $http, $timeout) ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, el, attrs, ctrl) ->

      # usernames = [ 'leb', 'kyr', 'valya']

      ctrl.$asyncValidators.userNameExists = (modelValue, viewValue) ->

        if ctrl.$isEmpty modelValue
          return $q.when()

        dfd = `$q.defer()`

        $http.post '/user/exists/', userName: modelValue
        .then (response) ->
          unless response.data.exists
            dfd.resolve()
          else
            dfd.reject()

        # this was left for further possible testing attempts
        # $timeout () ->
        #   if usernames.indexOf(modelValue) is -1
        #     dfd.resolve()
        #   else
        #     dfd.reject()
        # , 3000

        return dfd.promise