# require 'modernizr'
# require 'polyfiller'
angular = require 'angular'
require 'angular-datepicker'
require 'angular-cookie'
require 'ng-token-auth'
require 'angular-resource'
require 'angular-route'
require 'angular-animate'
require 'angular-ui-bootstrap'
require 'angular-growl-v2'
require './index/index.client.module'
require './users/users.client.module'
require './projects/projects.client.module'

# webshims.setOptions 'waitReady', off
# webshims.setOptions 'forms-ext', types: 'date'
# webshims.polyfill 'forms forms-ext'

mainApplicationModuleName = 'taskManager'

mainApplicationModule = angular.module mainApplicationModuleName,
  ['ngRoute', 'ngResource', 'ngAnimate', 'ng-token-auth',
    'ui.bootstrap', 'angular-growl', 'index', 'users', 'projects']

mainApplicationModule.config ['$locationProvider', ($locationProvider) ->
  $locationProvider.hashPrefix '!'
]

mainApplicationModule.config ['growlProvider', (growlProvider) ->
  growlProvider.onlyUniqueMessages on
  growlProvider.globalTimeToLive 2000
]

mainApplicationModule.config ['$authProvider', ($authProvider) ->
  $authProvider.configure
    apiUrl: ''
    # validateOnPageLoad: off
]

# mainApplicationModule.run ['$auth', 'Identity', ($auth, Identity) ->
  # $auth.validateUser().then (user) ->
    # Identity.user = user
# ]

require './common'

if window.location.hash is '#_=_'
  window.location.hash = '#!'

angular.element(document).ready () ->
  angular.bootstrap document, [mainApplicationModuleName]
