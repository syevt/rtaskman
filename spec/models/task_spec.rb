describe Task do
  context 'association' do
    it { is_expected.to belong_to(:project) }
  end

  context 'done' do
    it { is_expected.to allow_value(true).for(:done) }
    it { is_expected.to allow_value(false).for(:done) }
    it { is_expected.to allow_value(nil).for(:done) }
  end

  context 'content' do
    include_examples 'text field', :content
  end

  context 'priority' do
    it do
      is_expected.to validate_numericality_of(:priority)
        .only_integer
        .is_greater_than_or_equal_to(0)
    end
  end
end
