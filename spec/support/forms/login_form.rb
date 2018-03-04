class LoginForm
  include Rails.application.routes.url_helpers
  include AbstractController::Translation
  include Capybara::DSL

  def fill_in_with(params)
    visit root_path
    fill_in(t('home.index.email'), with: params[:email])
    fill_in(t('home.index.password'), with: params[:password])
    click_on(t('home.index.login'))
  end
end
