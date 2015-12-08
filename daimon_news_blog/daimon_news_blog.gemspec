$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "daimon_news_blog/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "daimon_news_blog"
  s.version     = DaimonNewsBlog::VERSION
  s.authors     = ["Masafumi Yokoyama"]
  s.email       = ["yokoyama@clear-code.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of DaimonNewsBlog."
  s.description = "TODO: Description of DaimonNewsBlog."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"

  s.add_development_dependency "sqlite3"
end
