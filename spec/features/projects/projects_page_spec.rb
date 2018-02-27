feature 'Projects page', js: true do
  include_context 'client translations'

  given!(:user) { create(:user) }
  given(:project_tr) { translations['projects'] }
  given(:common_tr) { translations['common'] }
  given!(:projects) { create_list(:project_with_tasks, 2, user: user) }

  background { sign_in(user) }

  scenario "click on 'Add todo list' adds new project to page" do
    find('span', text: project_tr['addProject']).trigger('click')
    new_project_name = 'Some new project'
    find('input', match: :first).set(new_project_name)
    click_on(project_tr['addButton'])
    expect(page).to have_css('.tm-project-name', text: new_project_name)
  end

  scenario "click on 'Edit project' to change project name" do
    find("i[title='#{project_tr['editButton']}']",
         visible: false, match: :first).trigger('click')
    edited = 'changed project name'
    find('input', match: :first).set(edited)
    click_on(project_tr['save'])
    expect(page).to have_css('.tm-project-name', text: edited)
    expect(page).not_to have_css('.tm-project-name', text: projects.first.name)
  end

  context "click on 'Delete project'" do
    background do
      find("i[title='#{project_tr['deleteButton']}']",
           visible: false, match: :first).trigger('click')
    end

    scenario 'removes project from page when conirmed in modal' do
      click_on(common_tr['delete'])
      expect(page).not_to have_css('.tm-project-name',
                                   text: projects.first.name)
      expect(page).to have_css('.tm-project-name', count: 1)
    end

    scenario 'leaves project on page when canceled in modal' do
      click_on(common_tr['cancel'])
      expect(page).to have_css('.tm-project-name', text: projects.first.name)
      expect(page).to have_css('.tm-project-name', count: 2)
    end
  end
end
