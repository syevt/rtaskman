describe 'tmEmailValidator directive', ()->
  scope = {}
  form = {}

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$rootScope', '$compile')
    scope = $rootScope
    el = angular.element('<form name="vm.userForm">' +
      '<input ng-model="vm.email" name="email" tm-email-validator />' +
      '</form>')
    $compile(el)(scope)
    form = scope.vm.userForm

  valid_emails = ['some@email.com', 'some.another@email.com',
                  'some_another@email.com', 'some@email.another.com',
                  'some@email.tuv.xyz.com', '7some@email.com',
                  'some@email.555.xyz.com']

  context 'returns true for', ()->
    for email in valid_emails
      do (email)->
        it "#{email}", ()->
          form.email.$setViewValue(email)
          scope.$apply()
          expect(form.email.$valid).to.be.true

  invalid_emails = ['some', '@email.com', '.some@email.com', 'some.@email.com',
                    'some@email.com.', 'some@em#ail.com', 'some@.email.com',
                    'some@email..com']

  context 'returns false for', ()->
    for email in invalid_emails
      do (email)->
        it "#{email}", ()->
          form.email.$setViewValue(email)
          scope.$apply()
          expect(form.email.$valid).to.be.false
