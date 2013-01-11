$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mustache_render/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mustache_render"
  s.version     = MustacheRender::VERSION
  s.authors     = ["happy"]
  s.email       = ["andywang7259@gmail.com"]
  s.homepage    = "http://blogsoso.net/"
  s.summary     = "Summary of MustacheRender."
  s.description = "Description of MustacheRender."

  s.files = Dir["{app,config,db,lib,spec}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "mustache", "~> 0.99.4"
  s.add_dependency "awesome_nested_set"

  # s.add_dependency "rails", "~> 3.2.10"

  s.add_development_dependency "sqlite3"
end
