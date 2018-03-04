require_relative '../../support/forms/login_form'

feature 'Login/logout', js: true do
  include_context 'client translations'

  given(:auth_tr) { translations['auth'] }
  given(:login_form) { LoginForm.new }

  [['', ''], ['', 'wrong'], ['wrong', ''], ['wrong', 'wrong']].each do |creds|
    scenario "with login '#{creds.first}' and password '#{creds.last}' "\
      "shows 'invalid credentials' error" do
      login_form.fill_in_with(email: creds.first, password: creds.last)
      expect(page).to have_text('Invalid credentials')
    end
  end

  scenario "with valid credentials shows 'logged in' message" do
    user = create(:user)
    login_form.fill_in_with(email: user.email, password: user.password)
    expect(page).to have_text(auth_tr['loggedIn'])
  end

  scenario "when logged in user clicks 'logout' shows 'logged out' message" do
    user = create(:user)
    sign_in(user)
    find_link(user.email).trigger('click')
    find_link(t('home.index.signout')).trigger('click')
    expect(page).to have_text(auth_tr['loggedOut'])
  end
end
