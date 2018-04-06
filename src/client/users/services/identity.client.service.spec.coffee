describe 'Identity service', ()->
  beforeEach ()->
    bard.appModule('taskManager')
    bard.inject('Identity')

  context '#isAuthenticated', ()->
    it 'with @user undefined returns false', ()->
      expect(Identity.isAuthenticated()).to.be.false

    it 'with @user.signedIn undefined returns false', ()->
      Identity.user = {}
      expect(Identity.isAuthenticated()).to.be.false

    it 'with @user.signedIn equal false returns false', ()->
      Identity.user = signedIn: off
      expect(Identity.isAuthenticated()).to.be.false

    it 'with @user.signedIn equal true returns true', ()->
      Identity.user = signedIn: on
      expect(Identity.isAuthenticated()).to.be.true
