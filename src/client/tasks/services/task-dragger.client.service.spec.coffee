describe 'taskDragger', ()->
  dragEvent = {}
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('$q', '$rootScope', 'taskDragger', 'taskDraggerHelper',
      'Task', 'growl')

    bard.mockService taskDraggerHelper,
        isValidTarget: sandbox.stub().returns(on)
        offsets: ()-> [1, 2]
        sourceElement: ()-> {}
        _default: sandbox.spy()

    dragEvent =
      currentTarget: document.createElement('tr')
      dataTransfer:
        dropEffect: ''
        effectAllowed: ''
        setData: sandbox.spy()
        setDragImage: sandbox.spy()
      preventDefault: sandbox.spy()
      stopPropagation: sandbox.spy()

  afterEach ()->
    sandbox.restore()

  context '#dragstart returns drag event handler that', ()->
    beforeEach ()->
      handler = taskDragger.dragstart({id: 0}, {id: 1})
      handler(dragEvent)

    it 'calls stopPropagation() on passed event', ()->
      expect(dragEvent.stopPropagation).to.have.been.called

    it "sets 'move' allowed effect on passed event", ()->
      expect(dragEvent.dataTransfer.effectAllowed).to.eq('move')

    it "sets non-empty string to 'text/html' key", ()->
      expect(dragEvent.dataTransfer.setData)
        .to.have.been.calledWithMatch('text/html', /\S/)

    it 'calls helper`s setSourceData', ()->
      expect(taskDraggerHelper.setSourceData).to.have.been.called

    it 'sets drag image on passed event', ()->
      expect(dragEvent.dataTransfer.setDragImage)
        .to.have.been.calledWith({}, 1, 2)

  context '#dragenter returns drag event handler that', ()->
    handler = {}
    addCss = {}

    beforeEach ()->
      addCss = sandbox.spy(dragEvent.currentTarget.classList, 'add')
      handler = taskDragger.dragenter({id: 0}, {id: 1, priority: 5})

    it 'checks if the current task <tr> is valid target', ()->
      handler(dragEvent)
      expect(taskDraggerHelper.isValidTarget).to.have.been.called

    it "adds 'below' css class when dragging downwards", ()->
      sandbox.stub(sessionStorage, 'getItem').returns('2')
      handler(dragEvent)
      expect(addCss).to.have.been.calledWithMatch(/below/)

    it "adds 'above' css class when dragging upwards", ()->
      sandbox.stub(sessionStorage, 'getItem').returns('7')
      handler(dragEvent)
      expect(addCss).to.have.been.calledWithMatch(/above/)

  context '#dragover returns drag event handler that', ()->
    beforeEach ()->
      handler = taskDragger.dragover({id: 0}, {id: 1})
      handler(dragEvent)

    it 'checks if the current task <tr> is valid target', ()->
      expect(taskDraggerHelper.isValidTarget).to.have.been.called

    it "sets 'move' drop effect on passed event", ()->
      expect(dragEvent.dataTransfer.dropEffect).to.eq('move')

    it 'calls preventDefault() on passed event', ()->
      expect(dragEvent.preventDefault).to.have.been.called

  context '#dragleave returns drag event handler that', ()->
    handler = {}

    beforeEach ()->
      handler = taskDragger.dragleave({id: 0}, {id: 1})

    it 'checks if the current task <tr> is valid target', ()->
      handler(dragEvent)
      expect(taskDraggerHelper.isValidTarget).to.have.been.called

    it "ensures both 'below' and 'above' css classes to be removed", ()->
      removeCss = sandbox.spy(dragEvent.currentTarget.classList, 'remove')
      handler(dragEvent)
      expect(removeCss.args[0]).to.match(/below/)
      expect(removeCss.args[1]).to.match(/above/)

  context '#drop returns drag event handler that', ()->
    handler = {}

    beforeEach ()->
      handler = taskDragger.drop({id: 0}, {id: 1, priority: 2})

    it 'checks if the current task <tr> is valid target', ()->
      handler(dragEvent)
      expect(taskDraggerHelper.isValidTarget).to.have.been.called

    it "ensures both 'below' and 'above' css classes to be removed", ()->
      removeCss = sandbox.spy(dragEvent.currentTarget.classList, 'remove')
      handler(dragEvent)
      expect(removeCss.args[0]).to.match(/below/)
      expect(removeCss.args[1]).to.match(/above/)

    context 'updates task', ()->
      beforeEach ()->
        sandbox.stub(sessionStorage, 'getItem').returns('4')

      it 'with successful response reorders project tasks', ()->
        sandbox.stub(Task.prototype, '$update').returns($q.when())
        handler(dragEvent)
        $rootScope.$apply()
        expect(taskDraggerHelper.reorderTasks).to.have.been.called

      it 'with error response makes growl show error message', ()->
        error = 'reorder error'
        sandbox.spy(growl, 'error')
        sandbox.stub(Task.prototype, '$update')
          .returns($q.reject(data: {errors: [error]}))
        handler(dragEvent)
        $rootScope.$apply()
        expect(growl.error).to.have.been.calledWithMatch(error, ttl: -1)
