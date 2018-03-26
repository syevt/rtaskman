describe.only 'taskDragger', ()->
  dragEvent = {}
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('taskDragger', 'taskDraggerHelper', 'Task', 'growl')

    bard.mockService taskDraggerHelper,
        isValidTarget: ()-> on
        offsets: ()-> [1, 2]
        sourceElement: ()-> {}
        _default: sandbox.spy()

    dragEvent =
      stopPropagation: sandbox.spy()
      dataTransfer:
        effectAllowed: ''
        setData: sandbox.spy()
        setDragImage: sandbox.spy()

  afterEach ()->
    sandbox.restore()

  context '#dragstart returns event handler that', ()->
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
