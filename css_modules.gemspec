$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "css_modules/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "css_modules"
  s.version     = CSSModules::VERSION
  s.authors     = ["Robert Mosolgo"]
  s.email       = ["rdmosolgo@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of CSSModules."
  s.description = "TODO: Description of CSSModules."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "css_parser"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "execjs"
end
