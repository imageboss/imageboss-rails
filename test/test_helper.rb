# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
require 'logger'
TEST_ROOT = File.dirname(__FILE__)
require File.expand_path('dummy/config/environment.rb', TEST_ROOT)

# Minimal test setup: no ActiveRecord, no DB. We use active_support/test_case and minitest only.
require 'active_support/test_case'
require 'minitest/autorun'

Minitest.backtrace_filter = Minitest::BacktraceFilter.new
