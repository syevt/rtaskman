feature 'Home page' do
  context 'with guest user' do
    scenario 'has signin/signup controls' do
      visit root_path
      expect(page).to have_text(t('home.index.brand'))
      expect(page).to have_link(t('home.index.signup'))
      expect(page).to have_field(t('home.index.email'))
      expect(page).to have_field(t('home.index.password'))
      expect(page).to have_button(t('home.index.login'))
    end
  end

  context 'with logged in user', js: true do
    include_context 'client translations'

    given!(:user) { create(:user) }
    given(:js_tr) { translations['projects'] }

    shared_examples 'no auth elements' do
      scenario 'has no signin/signup controls' do
        expect(page).not_to have_link(t('home.index.signup'))
        expect(page).not_to have_field(t('home.index.email'))
        expect(page).not_to have_field(t('home.index.password'))
        expect(page).not_to have_button(t('home.index.login'))
      end
    end

    context 'with user having no projects' do
      background { sign_in(user) }

      include_examples 'no auth elements'

      scenario 'has empty projects page' do
        expect(page).not_to have_css('.tm-project-name')
        expect(page).not_to have_css('.tm-task-caption')
        expect(page).to have_text(js_tr['addProject'])
        expect(page).to have_text(js_tr['noProjectsMessage'])
      end
    end

    context 'with user having projects' do
      background do
        create_list(:project_with_tasks, 3, user: user)
        sign_in(user)
      end

      include_examples 'no auth elements'

      scenario 'has user`s projects on page' do
        expect(page).to have_css('.tm-project-name', count: 3)
        expect(page).to have_css('.tm-task-caption', count: 6)
        expect(page).not_to have_text(js_tr['noProjectsMessage'])
      end
    end
  end
end
