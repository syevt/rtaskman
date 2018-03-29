describe 'Tasks API' do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }

  context 'POST api/v1/tasks' do
    include_examples 'unauthenticated', :post, :api_v1_tasks_path

    context 'with logged in user' do
      let(:content) { 'some weird task' }
      let(:params) { { task: { project_id: project.id, content: content } } }

      it 'returns new task json' do
        post(api_v1_tasks_path, params: params, headers: headers)
        expect(response.status).to eq(200)
        expect(response).to match_response_schema('task')
        expect(json[:content]).to eq(content)
      end

      it "with no tasks in project returns new task with '0' priority" do
        post(api_v1_tasks_path, params: params, headers: headers)
        expect(json[:priority]).to eq(0)
      end

      it "with tasks in project returns new task with 'max + 1' priority" do
        project.tasks << [build(:task, priority: 42),
                          build(:task, priority: 11)]
        project.save
        post(api_v1_tasks_path, params: params, headers: headers)
        expect(json[:priority]).to eq(43)
      end
    end
  end

  context 'PUT api/v1/tasks/:id' do
    include_examples 'unauthenticated', :put, :api_v1_task_path, 1

    context 'with logged in user' do
      context 'with task belonged to user`s project' do
        it 'updates task`s attributes' do
          task = create(:task, project: project)
          attrs = { done: true, content: 'i was changed',
                    deadline: (DateTime.now + 42.days).strftime('%F') }
          put(api_v1_task_path(task), params: { task: attrs }, headers: headers)
          expect(response.status).to eq(200)
          expect(response).to match_response_schema('task')
          attrs.each { |key, value| expect(json[key]).to eq(value) }
        end

        context 'changes both this task`s and other tasks` priorities' do
          cases = {
            [0, 5] => [[*0..5], [5, 0, 1, 2, 3, 4]],
            [5, 0] => [[*0..5], [1, 2, 3, 4, 5, 0]],
            [0, 4] => [[*0..5], [4, 0, 1, 2, 3, 5]],
            [4, 0] => [[*0..5], [1, 2, 3, 4, 0, 5]],
            [1, 5] => [[*0..5], [0, 5, 1, 2, 3, 4]],
            [5, 1] => [[*0..5], [0, 2, 3, 4, 5, 1]],
            [2, 3] => [[*0..5], [0, 1, 3, 2, 4, 5]],
            [3, 2] => [[*0..5], [0, 1, 3, 2, 4, 5]],
            [3, 11] => [[3, 5, 6, 11, 12, 42, 98], [11, 4, 5, 10, 12, 42, 98]],
            [11, 3] => [[3, 5, 6, 11, 12, 42, 98], [4, 6, 7, 3, 12, 42, 98]],
            [6, 98] => [[3, 5, 6, 11, 12, 42, 98], [3, 5, 98, 10, 11, 41, 97]],
            [98, 6] => [[3, 5, 6, 11, 12, 42, 98], [3, 5, 7, 12, 13, 43, 6]],
            [5, 12] => [[3, 5, 6, 11, 12, 42, 98], [3, 12, 5, 10, 11, 42, 98]],
            [42, 6] => [[3, 5, 6, 11, 12, 42, 98], [3, 5, 7, 12, 13, 6, 98]]
          }
          cases.each do |priorities, sets|
            it "for priorities #{sets.first} drag #{priorities.first} to "\
             "#{priorities.last} gives #{sets.last} sequence" do
              tasks = sets.first.map do |number|
                create(:task, project: project, priority: number)
              end

              target = tasks.find { |task| task.priority == priorities.last }

              put(api_v1_task_path(target),
                  params: { task: { sourcepriority: priorities.first } },
                  headers: headers)

              expect(tasks.each(&:reload).map(&:priority)).to eq(sets.last)
            end
          end
        end
      end

      it 'with task belonged to other user`s project returns error' do
        task = create(:task, project: create(:project, user: create(:user)))
        put(api_v1_task_path(task),
            params: { task: { content: 'whatever' } },
            headers: headers)
        expect(response.status).to eq(403)
        expect(json[:errors].first).to eq(t('cancancan.unauthorized'))
      end
    end
  end

  context 'DELETE api/v1/tasks' do
    include_examples 'unauthenticated', :delete, :api_v1_task_path, 1

    context 'with task belonged to project belonged to user' do
      let!(:task) { create(:task, project: project) }

      it 'returns deleted task' do
        delete(api_v1_task_path(task), headers: headers)
        expect(response.status).to eq(200)
        expect(response).to match_response_schema('task')
        expect(json[:content]).to eq(task.content)
      end

      it 'removes task from database' do
        expect {
          delete(api_v1_task_path(task), headers: headers)
        }.to change(Task, :count).by(-1)
      end
    end

    context 'with task belonged to other user`s project' do
      let!(:task) do
        create(:task, project: create(:project, user: create(:user)))
      end

      it 'returns error' do
        delete(api_v1_task_path(task), headers: headers)
        expect(response.status).to eq(403)
        expect(json[:errors].first).to eq(t('cancancan.unauthorized'))
      end

      it 'doesn`t remove task from database' do
        expect {
          delete(api_v1_task_path(task), headers: headers)
        }.not_to change(Task, :count)
      end
    end
  end
end
