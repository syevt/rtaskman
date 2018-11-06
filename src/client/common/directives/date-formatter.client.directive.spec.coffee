describe 'tmDateFormatter directive', ()->
  it "formats 'yyyy-mm-dd' date string to valid js date object", ()->
    bard.appModule('taskManager')
    bard.inject('$rootScope', '$compile')
    scope = $rootScope.$new()
    el = angular.element('<form name="testForm">' +
      '<input name="dateInput" type="date" ' +
      'ng-model="vm.currentTask.deadline" tm-date-formatter />'
      '<form/>')
    $compile(el)(scope)
    scope.testForm.dateInput.$setViewValue('2017-02-10')
    scope.$apply()
    expect(scope.vm.currentTask.deadline).to.be.a('Date')
