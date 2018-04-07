shared_examples 'text field' do |field|
  it { is_expected.to validate_presence_of(field) }
  it { is_expected.to allow_value('Some content').for(field) }
  it { is_expected.to allow_value("Полум'яний блиск").for(field) }

  it do
    is_expected.to allow_value(
      "Some 'content' with/without \"additional chars\", like commas(,),"\
      'hyphens(-) isn`t allowed!?'
    ).for(field)
  end

  it { is_expected.not_to allow_value('#with <special @symbols>').for(field) }
end
