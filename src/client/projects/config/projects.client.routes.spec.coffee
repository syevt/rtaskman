describe 'projects routes', ()->
  beforeEach ()->
    module('taskManager')
    bard.inject('$route', '$location', '$rootScope')
    $location.path('/projects')
    $rootScope.$apply()

  it "routing to '/projects' loads 'projects-list' view", ()->
    expect($route.current.templateUrl)
      .to.match(/projects\/views\/list-projects/)

  it 'wires up Projects controller', ()->
    expect($route.current.controller).to.match(/Projects/)
