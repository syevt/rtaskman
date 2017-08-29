require('angular').module('users').factory 'Identity', ['$window', ($window) ->
  user: @user
  isAuthenticated: () ->
    !!@user
]
