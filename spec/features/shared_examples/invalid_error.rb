shared_examples 'invalid error' do
  scenario "shows 'invalid' error" do
    expect(page).to have_text(common_tr['invalidError'])
  end
end
