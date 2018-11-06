shared_examples 'empty error' do
  scenario "shows 'empty' error" do
    expect(page).to have_text(common_tr['emptyError'])
  end
end
