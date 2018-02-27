describe 'Projects API', type: :request do
  it "returns 'unauthenticated' error when not logged in" do
    get(api_v1_projects_path)
    expect(response.status).to eq(401)
    expect(json[:errors].first).to eq(t('devise.failure.unauthenticated'))
  end

  it 'returns current user`s projects' do
    user = create(:user)
    create_list(:project_with_tasks, 4, user: user)
    get(api_v1_projects_path, headers: user.create_new_auth_token)
    puts json
    expect(response.status).to eq(200)
    expect(response).to match_response_schema('projects')
  end
end
