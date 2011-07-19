# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "tintie"
  s.summary = "Collaborative Task Manager for Rails 3.1"
  s.description = "Very long description on why this gem is awesome."
  s.files = Dir["{app,lib,config,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.0.2"
  
  s.add_runtime_dependency("rails", ["~> 3.1.0.rc4"])
  
  s.add_development_dependency("rspec-rails", [">= 2.4.1"])
  s.add_development_dependency("capybara", [">= 0.4.0"])
  s.add_development_dependency("launchy", [">= 0.3.7"])
end