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


  s.add_dependency 'imageboss-rb', '~> 2.1.0'

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
end
