class SignupForm
  include Rails.application.routes.url_helpers
  include AbstractController::Translation
  include Capybara::DSL

  def fill_in_with(params)
    visit root_path
    click_link(t('home.index.signup'))
    within('.modal-body') do
      inputs = all('input')
      inputs[0].set(params[:email])
      inputs[1].set(params[:password])
      inputs[2].set(params[:confirm_password])
    end
    click_on(params[:btn])
  end
end
