describe 'Testing modules', ->
  module = null

  before ->
    module = angular.module('taskManager')

  it 'should be registered', ->
    expect(module).not.to.eq(null)
