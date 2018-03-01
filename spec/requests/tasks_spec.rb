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

      it 'doesn`t remove project from database' do
        expect {
          delete(api_v1_task_path(task), headers: headers)
        }.not_to change(Task, :count)
      end
    end
  end
end
