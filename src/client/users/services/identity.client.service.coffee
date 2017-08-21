require('angular').module('users').factory 'Identity', [ '$window', ($window) ->
  @user = $window.bootstrappedUserObject

  user: @user
  isAuthenticated: () ->
    !!@user
]