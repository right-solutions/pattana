$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pattana/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pattana"
  s.version     = Pattana::VERSION
  s.authors     = ["kpvarma"]
  s.email       = ["krshnaprsad@gmail.com"]
  s.homepage    = "https://github.com/right-solutions/pattana"
  s.summary     = "Simple User & Feature Permission Management"
  s.description = "Pattana gives you a user module with Admin Interface to Manage Features, Users and their permissions."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '~> 5.0', '>= 5.0.2'
  s.add_dependency 'jquery-rails', '~> 4.2', '>= 4.2.2'
  s.add_dependency 'kaminari', '~> 1.0', '>= 1.0.1'
  s.add_dependency 'bootstrap-kaminari-views', "~> 0.0.5"
  # s.add_dependency 'config', '~> 1.0'

  s.add_dependency 'kuppayam', "~> 0.1.5dev4"
  s.add_dependency "bcrypt"
  s.add_dependency "colorize"

  s.add_development_dependency 'pry', "~> 0.10.1", ">= 0.10.0"
  s.add_development_dependency 'mysql2', "~> 0.4.4"
  s.add_development_dependency 'carrierwave', "~> 0.10.0", ">= 0.9.0"
  s.add_development_dependency 'rmagick', "~> 2.13.3", ">= 2.13.2"
  s.add_development_dependency 'rspec-rails', "~> 3.5"
  s.add_development_dependency 'capybara', "~> 2.4.4", ">= 2.4.3"
  s.add_development_dependency 'factory_girl_rails', "~> 4.8.0", ">= 4.4.0"
  s.add_development_dependency 'database_cleaner', "~> 1.4.0", ">= 1.3.0"
  s.add_development_dependency 'shoulda-matchers', "~> 3.1"
  
end