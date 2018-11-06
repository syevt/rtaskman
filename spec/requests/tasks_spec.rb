describe 'Tasks API' do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }

  context 'POST api/v1/tasks' do
    include_examples 'unauthenticated', :post, :api_v1_tasks_path

    context 'with logged in user' do
      let(:content) { 'some weird task' }
      let(:params) { { task: { project_id: project.id, content: content } } }

      context 'with successful task creation' do
        it 'returns new task json' do
          post(api_v1_tasks_path, params: params, headers: headers)
          expect(response.status).to eq(200)
          expect(response).to match_response_schema('task')
          expect(json[:content]).to eq(content)
        end

        it 'adds new task to database' do
          expect {
            post(api_v1_tasks_path, params: params, headers: headers)
          }.to change(Task, :count).by(1)
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

      it 'with creation error returns error' do
        error = 'task creation error'
        allow_any_instance_of(Task).to(receive(:save).and_return(false))
        allow_any_instance_of(Task).to(
          receive_message_chain('errors.full_messages').and_return([error])
        )
        post(api_v1_tasks_path, params: params, headers: headers)
        expect(response.status).to eq(400)
        expect(json[:errors]).to eq([error])
      end
    end
  end

  context 'PUT api/v1/tasks/:id' do
    include_examples 'unauthenticated', :put, :api_v1_task_path, 1

    context 'with logged in user' do
      context 'with task belonged to user`s project' do
        let!(:task) { create(:task, project: project) }

        it 'with successful update returns updated task' do
          attrs = { done: true, content: 'i was changed',
                    deadline: (DateTime.now + 42.days).strftime('%F') }
          put(api_v1_task_path(task), params: { task: attrs }, headers: headers)
          expect(response.status).to eq(200)
          expect(response).to match_response_schema('task')
          attrs.each { |key, value| expect(json[key]).to eq(value) }
        end

        it 'with update error returns error' do
          error = 'update task error'
          allow_any_instance_of(Task).to(
            receive(:update_attributes).and_return(false)
          )
          allow_any_instance_of(Task).to(
            receive_message_chain('errors.full_messages').and_return([error])
          )
          put(api_v1_task_path(task),
              params: { task: { content: 'foo' } },
              headers: headers)
          expect(response.status).to eq(400)
          expect(json[:errors]).to eq([error])
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

    shared_examples 'doesn`t remove from db' do
      it 'doesn`t remove task from database' do
        expect {
          delete(api_v1_task_path(task), headers: headers)
        }.not_to change(Task, :count)
      end
    end

    context 'with task belonged to project belonged to user' do
      let!(:task) { create(:task, project: project) }

      context 'with successful deletion' do
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

      context 'with deletion error' do
        let(:error) { 'delete task error' }

        before do
          allow_any_instance_of(Task).to(
            receive(:destroy).and_return(false)
          )
          allow_any_instance_of(Task).to(
            receive_message_chain('errors.full_messages').and_return([error])
          )
        end

        it 'returns error' do
          delete(api_v1_task_path(task), headers: headers)
          expect(response.status).to eq(400)
          expect(json[:errors]).to eq([error])
        end

        include_examples 'doesn`t remove from db'
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

      include_examples 'doesn`t remove from db'
    end
  end
end
