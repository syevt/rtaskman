describe 'common module', ()->
  it 'should be registered', ()->
    expect(angular.module('common')).to.exist
