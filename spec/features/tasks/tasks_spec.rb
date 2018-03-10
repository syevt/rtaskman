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

  context 'drag`n`drop', use_selenium: true do
  # context 'drag`n`drop', js: true do
    given!(:other_project) do
      create(:project_with_tasks, tasks_count: 4, user: user)
    end

    background { sign_in(user) }

    scenario 'dragging to other project`s tasks doesn`t change tasks` order' do
    # scenario 'dragging to other project`s task doesn`t change tasks` order', use_selenium: true do
      target_sequence = other_project.tasks.map(&:content)
      sleep 2
      source_project_el = all('.tm-project-container')[0]
      drag_button_el = within(source_project_el) do
        all("i[title='#{task_tr['changePriorityHint']}']", visible: false)[1]
      end
      target_project_el = all('.tm-project-container')[1]
      target_task = within(target_project_el) { all('.tm-task-row')[1] }
      drag_button_el.drag_to(target_task)
      target_sequence_after = within(target_project_el) do
        all('.tm-task-content').map(&:text)
      end
      expect(target_sequence_after).to eq(target_sequence)
    end

    # scenario 'dragging to same project`s task changes tasks` order', use_selenium: true do
    scenario 'dragging to same project`s task changes tasks` order' do
      # target_sequence = other_project.tasks.map(&:content)
      # puts target_sequence
      sleep 2
      driver = page.driver.browser
      # source_project_el = all('.tm-project-container')[1]
      # drag_button_el = within(source_project_el) do
        # # all("i[title='#{task_tr['changePriorityHint']}']", visible: false)[1]
        # all('.fa-sort', visible: false)[1]
      # end
      drag_button_el = all('#goo')[0]
      # target_project_el = source_project_el
      # target_task = within(target_project_el) { all('.tm-task-row')[3] }
      driver.action.move_to(drag_button_el.native).perform
      # drag_button_el.trigger('mouseenter')
      # expect(page).to have_text('I`m a tooltip???')
      sleep 15
      # driver.action.click_and_hold.perform
      # driver.action.move_by(100, 100).perform
      # driver.action
            # .click_and_hold(drag_button_el)
            # .move_to(target_task.native)
            # .release
            # .perform
      # drag_button_el.hover.drag_to(target_task).mouseup
      # driver.drag_and_drop(drag_button_el.native, target_task.native).perform
      # drag_button_el.drag_to(target_task)
      # sleep 15
      # target_sequence_after = within(target_project_el) do
        # all('.tm-task-content').map(&:text)
      # end
      # expect(target_sequence_after).not_to eq(target_sequence)
    end
  end
end
