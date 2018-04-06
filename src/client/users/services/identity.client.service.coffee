(->
  Identity = ()->
    user: @user
    isAuthenticated: ()-> !!@user?.signedIn

  require('angular').module('users').factory('Identity', Identity)
)()
