describe 'Projects API' do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }

  context 'GET api/v1/projects' do
    include_examples 'unauthenticated', :get, :api_v1_projects_path

    it 'with logged in user returns his projects' do
      create_list(:project_with_tasks, 4, user: user)
      get(api_v1_projects_path, headers: headers)
      expect(response.status).to eq(200)
      expect(response).to match_response_schema('projects')
    end
  end

  context 'POST api/v1/projects' do
    include_examples 'unauthenticated', :post, :api_v1_projects_path

    context 'with logged in user' do
      it 'returns new project' do
        name = 'some fancy project'
        post(api_v1_projects_path, params: { project: { name: name } },
                                   headers: headers)
        expect(response.status).to eq(200)
        expect(response).to match_response_schema('project')
        expect(json[:name]).to eq(name)
      end

      it 'adds new project to database' do
        expect {
          post(api_v1_projects_path, params: { project: { name: 'some name' } },
                                     headers: headers)
        }.to change(Project, :count).by(1)
      end
    end
  end

  context 'PUT api/v1/projects/:id' do
    include_examples 'unauthenticated', :put, :api_v1_project_path, 1

    context 'with logged in user' do
      it 'with project belonged to user changes its name' do
        project = create(:project, user: user)
        name = 'project changed name'
        put(api_v1_project_path(project),
            params: { project: { name: name } },
            headers: headers)
        expect(response.status).to eq(200)
        expect(response).to match_response_schema('project')
        expect(json[:name]).to eq(name)
      end

      it 'with other user`s project returns error' do
        project = create(:project, user: create(:user))
        put(api_v1_project_path(project),
            params: { project: { name: 'changed name' } },
            headers: headers)
        expect(response.status).to eq(403)
        expect(json[:errors].first).to eq(t('cancancan.unauthorized'))
      end
    end
  end

  context 'DELETE api/v1/projects/:id' do
    include_examples 'unauthenticated', :delete, :api_v1_project_path, 1

    context 'with logged in user' do
      context 'with project belonged to user' do
        let!(:project) { create(:project, user: user) }

        it 'returns deleted project' do
          delete(api_v1_project_path(project), headers: headers)
          expect(response.status).to eq(200)
          expect(response).to match_response_schema('project')
          expect(json[:name]).to eq(project.name)
        end

        it 'removes project from database' do
          expect {
            delete(api_v1_project_path(project), headers: headers)
          }.to change(Project, :count).by(-1)
        end
      end

      context 'with other user`s project' do
        let!(:project) { create(:project, user: create(:user)) }

        it 'returns error' do
          delete(api_v1_project_path(project), headers: headers)
          expect(response.status).to eq(403)
          expect(json[:errors].first).to eq(t('cancancan.unauthorized'))
        end

        it 'doesn`t remove project from database' do
          expect {
            delete(api_v1_project_path(project), headers: headers)
          }.not_to change(Project, :count)
        end
      end
    end
  end
end
