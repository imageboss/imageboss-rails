# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
# Ensure stdlib Logger is loaded before Rails (fixes ActiveSupport::LoggerThreadSafeLevel on Ruby 2.7 + Rails 6.1)
require 'logger'
TEST_ROOT = File.dirname(__FILE__)
require File.expand_path('dummy/config/environment.rb', TEST_ROOT)
ActiveRecord::Migrator.migrations_paths = [File.expand_path('dummy/db/migrate', TEST_ROOT)]
require 'rails/test_help'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load fixtures from the engine (only if fixtures directory exists)
fixtures_path = File.expand_path('fixtures', TEST_ROOT)
if ActiveSupport::TestCase.respond_to?(:fixture_path=) && Dir.exist?(fixtures_path)
  ActiveSupport::TestCase.fixture_path = fixtures_path
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path if defined?(ActionDispatch::IntegrationTest) && ActionDispatch::IntegrationTest.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.file_fixture_path = File.join(ActiveSupport::TestCase.fixture_path, 'files')
  ActiveSupport::TestCase.fixtures :all
end
