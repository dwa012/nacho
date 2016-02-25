$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nacho/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'nacho'
  s.version     = Nacho::VERSION
  s.authors     = ['Daniel Ward']
  s.email       = ['dwa012@gmail.com']
  s.homepage    = 'https://github.com/dwa012/nacho'
  s.summary     = 'A select helper to allow for creating related records'
  s.description = 'Adds a new form helper to create releated records via ajax. Allow the user to stay in the current form, creating a smoother user experience'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 4.0.0'

  s.add_development_dependency 'yard'
  s.add_development_dependency 'sqlite3'
end
