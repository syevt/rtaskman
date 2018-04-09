# feature 'Tasks on projects page', js: true do
feature 'Tasks on projects page' do
  include_context 'client translations'

  given!(:user) { create(:user) }
  given(:task_tr) { translations['tasks'] }
  given(:common_tr) { translations['common'] }
  given!(:project) { create(:project_with_tasks, user: user) }

  context 'CRUD actions', js: true do
    background { sign_in(user) }

    scenario "click on 'Add task' adds new task to project" do
      new_task_name = 'Some new task'
      fill_in(task_tr['newTaskHint'], with: new_task_name)
      click_on(task_tr['addButton'])
      expect(page).to have_css('td.tm-task-content p', text: new_task_name)
    end

    scenario "click on 'Edit task' to change task name" do
      task = project.tasks.first
      edited = 'changed task content'
      find("i[title='#{task_tr['editContentHint']}']",
           visible: false, match: :first).trigger('click')
      within("#task-#{project.id}-#{task.id}") do
        all('input')[1].set(edited)
      end
      click_on(task_tr['saveButton'])
      expect(page).to have_css('td.tm-task-content p', text: edited)
      expect(page).not_to have_css('td.tm-task-content p', text: task.content)
    end

    context 'outdated task' do
      given!(:task) do
        create(:task, deadline: DateTime.now - 1.day, project: project)
      end

      scenario 'shows warning bell' do
        expect(page).to have_css('i.tm-task-bell', count: 1)
      end

      scenario "click on 'Toggle done/undone' removes warning bell" do
        within("#task-#{project.id}-#{task.id}") do
          find("input[type='checkbox']").set(true)
        end

        expect(page).not_to have_css('i.tm-task-bell')
      end
    end

    context "click on 'Delete task'" do
      given(:content) { project.tasks.first.content }

      background do
        find("i[title='#{task_tr['deleteTaskHint']}']",
             visible: false, match: :first).trigger('click')
      end

      scenario 'removes task from project`s list when confirmed in modal' do
        click_on(common_tr['delete'])
        expect(page).not_to have_css('.tm-task-content', text: content)
        expect(page).to have_css('.tm-task-content', count: 1)
      end

      scenario 'leaves task in project`s list when canceled in modal' do
        click_on(common_tr['cancel'])
        expect(page).to have_css('.tm-task-content', text: content)
        expect(page).to have_css('.tm-task-content', count: 2)
      end
    end
  end
end
