require 'simplecov'
SimpleCov.start

require 'rails_helper'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'factory_girl_rails'
require 'json_matchers/rspec'
require 'wisper/rspec/matchers'
require_relative 'support/database_cleaner'
require_relative 'support/factory_girl'
require_relative 'support/feature/auth_helper'
require_relative 'support/request/json_helper'

['spec/**/shared_examples/*.rb', 'spec/**/shared_contexts/*.rb',
 'spec/helpers/*.rb'].each do |glob|
  Dir[Rails.root.join(glob)].each { |file| require file }
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    browser: :phantomjs,
    js_errors: true,
    debug: false
  )
end

# Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.around :each, type: :feature do |example|
    if example.metadata[:use_selenium]
      saved_driver = Capybara.current_driver
      Capybara.current_driver = :selenium
    end

    example.run

    Capybara.current_driver = saved_driver if example.metadata[:use_selenium]
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  # config.include Devise::Test::IntegrationHelpers, type: :feature
  # config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Rails.application.routes.url_helpers
  config.include Feature::AuthHelper, type: :feature
  config.include Request::JsonHelper, type: :request
  config.include Wisper::RSpec::BroadcastMatcher
end
