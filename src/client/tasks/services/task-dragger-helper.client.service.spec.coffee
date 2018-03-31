describe 'taskDraggerHelper', ()->
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('taskDraggerHelper')

  afterEach ()->
    sandbox.restore()

  context '#isValidTarget', ()->
    beforeEach ()->
      sandbox.stub(sessionStorage, 'getItem').returns('0')

    it 'with different tasks of the same project returns true', ()->
      project = id: 0
      task = id: 1
      expect(taskDraggerHelper.isValidTarget(project, task)).to.be.true

    it 'with tasks belonged to different projects returns false', ()->
      project = id: 1
      task = id: 1
      expect(taskDraggerHelper.isValidTarget(project, task)).to.be.false

    it 'with the same task returns false', ()->
      project = id: 0
      task = id: 0
      expect(taskDraggerHelper.isValidTarget(project, task)).to.be.false

  context '#offsets', ()->
    it 'returns offsets based on click x coordinate and element box size', ()->
      el = getBoundingClientRect: ()-> left: 50, height: 20
      expect(taskDraggerHelper.offsets(el, 200)).to.eql([150, 10])

  context '#setSourceData', ()->
    sessionSpy = {}

    beforeEach ()->
      sessionSpy = sandbox.spy(sessionStorage, 'setItem')
      taskDraggerHelper.setSourceData({id: 1}, {id: 2, priority: 3})

    it 'writes project id to session', ()->
      expect(sessionSpy).to.have.been.calledWith('projectId', 1)

    it 'writes task id to session', ()->
      expect(sessionSpy).to.have.been.calledWith('id', 2)

    it 'writes task`s priority to session', ()->
      expect(sessionSpy).to.have.been.calledWith('priority', 3)

  context '#sourceElement', ()->
    it 'gets source task`s html tr element', ()->
      spy = sandbox.spy(document, 'getElementById')
      taskDraggerHelper.sourceElement({id: 4}, {id: 5})
      expect(spy).to.have.been.calledWith('task-4-5')

  context '#reorderTasks with ids`=priorities` sequence 1, 2, 3, 4, 5, 6', ()->
    dragCases = [
      [1, 2, [2, 1, 3, 4, 5, 6]],
      [2, 1, [2, 1, 3, 4, 5, 6]],
      [1, 6, [2, 3, 4, 5, 6, 1]],
      [6, 1, [6, 1, 2, 3, 4, 5]],
      [5, 6, [1, 2, 3, 4, 6, 5]],
      [6, 5, [1, 2, 3, 4, 6, 5]],
      [3, 4, [1, 2, 4, 3, 5, 6]],
      [4, 3, [1, 2, 4, 3, 5, 6]],
      [4, 2, [1, 4, 2, 3, 5, 6]],
      [2, 4, [1, 3, 4, 2, 5, 6]],
      [5, 3, [1, 2, 5, 3, 4, 6]],
      [3, 5, [1, 2, 4, 5, 3, 6]]
    ]

    for drag in dragCases
      do (drag)->
        it "and dragging #{drag[0]} to #{drag[1]} gives ids` sequence \
        #{drag[2]}", ()->
          tasks = [1..6].map (id)-> {id: id, priority: id}
          taskDraggerHelper.reorderTasks(tasks, drag[1], drag[0])
          expect(tasks.map (task)-> task.id).to.eql(drag[2])
