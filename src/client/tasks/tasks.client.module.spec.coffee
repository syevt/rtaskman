describe 'tasks module', ()->
  it 'should be registered', ()->
    expect(angular.module('tasks')).to.exist
