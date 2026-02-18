$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'imageboss/rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'imageboss-rails'
  s.version     = ImageBoss::Rails::VERSION
  s.authors     = ['Igor Escobar']
  s.email       = ['igor@imageboss.me']
  s.homepage    = 'https://imageboss.me'
  s.summary     = 'Generate ImageBoss URLs with Ruby on Rails'
  s.description = 'Official Ruby On Rails gem for generating ImageBoss URLs'
  s.license     = 'MIT'

  s.test_files  = s.files.grep(%r{^(test|spec|features)/})

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']


  s.add_dependency 'imageboss-rb', '~> 2.1.1'

  rails_version = ENV["RAILS_VERSION"] || "default"

  rails = case rails_version
  when "master"
    {github: "rails/rails"}
  when "default"
    ">= 5.0.2"
  else
    "~> #{rails_version}"
  end

  s.add_dependency 'rails', rails

  # From Rails 5 onward, LineFiltering#run expects 2 args; Minitest 6 passes 3. Pin to 5.x when testing a specific Rails version.
  if rails_version != "default"
    s.add_development_dependency "minitest", "~> 5.14"
  end

  # Silence "will no longer be part of the default gems starting from Ruby 3.4.0" warnings in CI.
  s.add_development_dependency "bigdecimal"
  s.add_development_dependency "mutex_m"
  s.add_development_dependency "drb"
end
