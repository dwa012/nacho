$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nacho/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nacho"
  s.version     = Nacho::VERSION
  s.authors     = ["Daniel Ray Ward"]
  s.email       = ["drward3@uno.edu"]
  s.homepage    = "https://github.com/dwa012"
  s.summary     = "lorem ipsum"
  s.description = "lorem ipsum"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0.0"

  s.add_development_dependency "yard"
  s.add_development_dependency "sqlite3"
end
