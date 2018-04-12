describe 'textValidator service', ()->
  sandbox = sinon.createSandbox()

  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('textValidator', 'growl', '$translate')

  afterEach ()->
    sandbox.restore()

  context '#validate', ()->
    context 'null, undefined or empty', ()->
      for text in [null, undefined, '']
        do (text)->
          context "for '#{String(text)}'", ()->
            it "makes growl show 'empty' message", ()->
              emptyError = 'is empty'
              sandbox.stub($translate, 'instant').withArgs('common.emptyError')
                .returns(emptyError)
              sandbox.spy(growl, 'error')
              textValidator.validate(text)
              expect(growl.error).to.have.been.calledWith(emptyError)

            it 'returns false', ()->
              expect(textValidator.validate(text)).to.be.false

    context 'invalid text', ()->
      texts = ['<am> i invalid?', '# not allowed', 'curlies too {}',
               'foo ^ bar', 'bar & foo', 'no *s', 'and $s', 'or []s']
      for text in texts
        do (text)->
          context "for '#{text}'", ()->
            it "makes growl show 'invalid' message", ()->
              invalidError = 'is invalid'
              sandbox.stub($translate, 'instant').withArgs('common.invalidError')
                .returns(invalidError)
              sandbox.spy(growl, 'error')
              textValidator.validate(text)
              expect(growl.error).to.have.been.calledWith(invalidError)

            it 'returns false', ()->
              expect(textValidator.validate(text)).to.be.false

    context 'valid text', ()->
      texts = [
        'some text',
        'довільний текст',
        "Some 42 'текст' з/без \", like commas(,), hyphens(-) isn`t allowed!?"
      ]
      for text in texts
        do (text)->
          it "'#{text}' returns true", ()->
            expect(textValidator.validate(text)).to.be.true
                
