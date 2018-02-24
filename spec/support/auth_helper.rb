module AuthHelper
  include Rails.application.routes.url_helpers
  include AbstractController::Translation
  include Capybara::DSL

  def sign_in(user)
    visit root_path
    fill_in(t('home.index.email'), with: user.email)
    fill_in(t('home.index.password'), with: user.password)
    click_button(t('home.index.login'))
  end
end
