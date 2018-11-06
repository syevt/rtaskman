describe 'users module', ()->
  it 'should be registered', ()->
    expect(angular.module('users')).to.exist
