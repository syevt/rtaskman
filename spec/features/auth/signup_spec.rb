require_relative '../../support/forms/signup_form'

feature 'Signup', js: true do
  include_context 'client translations'

  given(:auth_tr) { translations['auth'] }
  given(:signup_form) { SignupForm.new }
  given(:ok) { auth_tr['addUser'] }
  given(:email) { Faker::Internet.email }
  given(:password) { Faker::Internet.password(8) }

  scenario "with empty fields shows 'input required' errors" do
    signup_form.fill_in_with(btn: ok)
    ['emailRequired', 'passwordRequired',
     'confirmPasswordRequired'].each do |error|
      expect(page).to have_text(auth_tr[error])
      expect(page).to have_css('.modal-header h3',
                               text: auth_tr['createAccount'])
    end
  end

  scenario 'with invalid email shows appropriate error' do
    signup_form.fill_in_with(email: 'kinda_email', btn: ok)
    expect(page).to have_text(auth_tr['validEmailNeeded'])
    expect(page).to have_css('.modal-header h3', text: auth_tr['createAccount'])
  end

  scenario 'with password shorter than 8 chars shows appropriate error' do
    signup_form.fill_in_with(email: email, password: '123', btn: ok)
    expect(page).to have_text(auth_tr['passwordLength'])
    expect(page).to have_css('.modal-header h3', text: auth_tr['createAccount'])
  end

  scenario 'with password confirmation not matching password shows error' do
    signup_form.fill_in_with(email: email, password: password,
                             confirm_password: '123', btn: ok)
    expect(page).to have_text(auth_tr['confirmPasswordMatch'])
    expect(page).to have_css('.modal-header h3', text: auth_tr['createAccount'])
  end

  scenario "with valid entries closes modal and shows 'user created' message" do
    signup_form.fill_in_with(email: email, password: password,
                             confirm_password: password, btn: ok)
    expect(page).not_to have_css('.modal-header h3',
                                 text: auth_tr['createAccount'])
    expect(page).to have_text(auth_tr['signedUp'])
    expect(page).to have_link(email)
  end

  scenario "with click on 'cancel' just closes modal" do
    signup_form.fill_in_with(btn: auth_tr['cancel'])
    expect(page).not_to have_css('.modal-header h3',
                                 text: auth_tr['createAccount'])
    expect(page).not_to have_text(auth_tr['signedUp'])
    expect(page).not_to have_link(email)
  end
end
