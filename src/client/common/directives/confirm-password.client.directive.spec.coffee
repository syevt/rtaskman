describe 'tmConfirmPassword directive', ()->
  scope = {}
  form = {}

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$rootScope', '$compile')
    scope = $rootScope
    el = angular.element('<form name="vm.userForm">' +
      '<input ng-model="vm.password" name="password" />' +
      '<input ng-model="vm.confirmPassword" name="confirmPassword"' +
      'tm-confirm-password />' +
      '</form>')
    $compile(el)(scope)
    form = scope.vm.userForm
    form.password.$modelValue = '12345678'

  it 'returns true if confirmPassword conforms to password', ()->
    form.confirmPassword.$setViewValue('12345678')
    scope.$apply()
    expect(form.confirmPassword.$valid).to.be.true

  it 'returns false if confirmPassword does not conform to password', ()->
    form.confirmPassword.$setViewValue('222')
    scope.$apply()
    expect(form.confirmPassword.$valid).to.be.false
