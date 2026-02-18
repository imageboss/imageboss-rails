source 'https://rubygems.org'

# Declare your gem's dependencies in imageboss-rails.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
gem 'byebug', group: [:development, :test]
# Ruby 3.x and Rails 8+ need sqlite3 >= 2.1 (1.4.x fails to compile on Ruby 3.3). Ruby 2.7 uses 1.4.x.
if ENV['RAILS_VERSION']&.start_with?('8.') || (RUBY_VERSION >= '3.0')
  gem 'sqlite3', '>= 2.1', group: [:development, :test]
else
  gem 'sqlite3', '~> 1.3', '<= 1.4.2', group: [:development, :test]
end
gem 'sass-rails', '~> 5.0.7', group: [:development, :test]
