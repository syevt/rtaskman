(->
  config = ($routeProvider)->
    $routeProvider
      .when('/', templateUrl: 'index/views/index.client.view.html')
      .otherwise(redirectTo: '/')

  config.$inject =  ['$routeProvider']

  require('angular').module('index').config(config)
)()
