describe 'index routes', ()->
  beforeEach ()->
    module('taskManager')
    bard.inject('$route', '$location', '$rootScope')

  it "routing to '/' loads 'index' view", ()->
    $location.path('/')
    $rootScope.$apply()
    expect($route.current.templateUrl).to.match(/index\/views\/index/)

  it "routing to non-existent path redirects to '/'", ()->
    $location.path('/foo/bar')
    $rootScope.$apply()
    expect($location.$$url).to.eq('/')
