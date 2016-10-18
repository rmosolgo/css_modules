$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "css_modules/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "css_modules"
  s.version     = CSSModules::VERSION
  s.authors     = ["Robert Mosolgo"]
  s.email       = ["rdmosolgo@gmail.com"]
  s.homepage    = "https://github.com/rmosolgo/css_modules"
  s.summary     = "Prevent naming conflicts in Sass stylesheets"
  s.description = "Provides a css-module-like experience to Sass/SCSS, Rails views and JavaScript"
  s.license     = "MIT"

  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "sass", "~>3.2"

  s.add_development_dependency "appraisal"
  s.add_development_dependency "execjs"
  s.add_development_dependency "sqlite3"
end
