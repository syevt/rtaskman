angular = require 'angular'
require 'angular-cookie'
require 'ng-token-auth'
require 'angular-resource'
require 'angular-route'
require 'angular-animate'
require 'angular-ui-bootstrap'
require 'angular-growl-v2'
require 'angular-translate'
require 'angular-translate-loader-url'
require 'angular-translate-loader-static-files'
require './common/common.client.module'
require './index/index.client.module'
require './users/users.client.module'
require './projects/projects.client.module'
require './tasks/tasks.client.module'

mainApplicationModuleName = 'taskManager'

mainApplicationModule = angular.module mainApplicationModuleName,
  ['ngRoute', 'ngResource', 'ngAnimate', 'ng-token-auth', 'ui.bootstrap',
   'angular-growl', 'pascalprecht.translate', 'common', 'index', 'users',
   'projects', 'tasks']

configure = ($locationProvider, growlProvider, $authProvider,
$qProvider, $translateProvider) ->
  $locationProvider.hashPrefix('!')
  growlProvider.onlyUniqueMessages(on)
  growlProvider.globalTimeToLive(2000)
  $authProvider.configure(apiUrl: '')
  $qProvider.errorOnUnhandledRejections(off)
  $translateProvider.useStaticFilesLoader
    prefix: 'languages/'
    suffix: '.json'
  $translateProvider.useSanitizeValueStrategy('escape')
  $translateProvider.preferredLanguage('en')

configure.$inject = ['$locationProvider', 'growlProvider', '$authProvider',
                     '$qProvider', '$translateProvider']

runBlock = ($auth, Identity) ->
  unless Identity.user
    $auth.validateUser().then (user) ->
      Identity.user = user

runBlock.$inject = ['$auth', 'Identity']

mainApplicationModule
  .config(configure)
  .run(runBlock)

if window.location.hash is '#_=_'
  window.location.hash = '#!'

angular.element(document).ready ->
  angular.bootstrap document, [mainApplicationModuleName]
