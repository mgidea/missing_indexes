$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "missing_indexes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "missing_indexes"
  s.version     = MissingIndexes::VERSION
  s.authors     = ["Tom Corley"]
  s.email       = ["tom.corley@goodmeasures.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of MissingIndexes."
  s.description = "TODO: Description of MissingIndexes."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.1"

  s.add_development_dependency "sqlite3"
end
