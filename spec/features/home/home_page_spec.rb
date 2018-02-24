feature 'Home page' do
  context 'with guest user' do
    scenario 'toolbar controls' do
      visit root_path
      expect(page).to have_text(t('home.index.brand'))
      expect(page).to have_link(t('home.index.signup'))
      expect(page).to have_field(t('home.index.email'))
      expect(page).to have_field(t('home.index.password'))
      expect(page).to have_button(t('home.index.login'))
    end
  end

  context 'with logged in user' do
    include_context 'client translations'
    given!(:user) { create(:user) }

    # scenario 'has no sign up link', use_selenium: true do
    scenario 'has no sign up link' do
      sign_in(user)
      expect(page).not_to have_link(t('home.index.signup'))
      expect(page).to have_text(translations['projects']['addProject'])
      expect(page).to have_text(translations['projects']['noProjectsMessage'])
    end
  end
end
