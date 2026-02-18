# Ensure stdlib Logger is loaded before Rails (fixes ActiveSupport::LoggerThreadSafeLevel on Ruby 2.7 + Rails 6.1)
require 'logger'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __dir__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
$LOAD_PATH.unshift File.expand_path('../../../lib', __dir__)
