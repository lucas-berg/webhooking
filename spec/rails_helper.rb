# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
abort('Refusing to run tests in production') if Rails.env.production?
require 'rspec/rails'
require 'capybara/rails'
require 'webmock/rspec'
require 'sidekiq'
Sidekiq.testing!(:fake)
require 'ffaker'
ActiveRecord::Migration.maintain_test_schema!
RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.infer_spec_type_from_file_location!
end
