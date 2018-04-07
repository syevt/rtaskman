describe Project do
  context 'association' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tasks).dependent(:destroy).autosave(true) }
  end

  context 'tasks scope' do
    it 'returns project`s tasks sorted by priority' do
      project = create(:project, user: create(:user))
      first_task = create(:task, project: project, priority: 3)
      second_task = create(:task, project: project, priority: 0)
      third_task = create(:task, project: project, priority: 1)
      expect(project.tasks.first).to eq(second_task)
      expect(project.tasks.second).to eq(third_task)
      expect(project.tasks.third).to eq(first_task)
    end
  end

  context 'name' do
    include_examples 'text field', :name
  end
end
