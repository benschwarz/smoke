Gem::Specification.new do |s|
  s.name              = "dependencies"
  s.version           = "0.0.6"
  s.summary           = "Specify your project's dependencies in one file."
  s.authors           = ["Damian Janowski", "Michel Martens"]
  s.email             = ["djanowski@dimaion.com", "michel@soveran.com"]

  s.rubyforge_project = "dependencies"

  s.executables << "dep"

  s.files = ["README.markdown", "Rakefile", "bin/dep", "dependencies.gemspec", "lib/dependencies/dep.rb", "lib/dependencies.rb", "test/dependencies_test.rb", "test/foobaz-0.3.gem", "test/vendor/bar/lib", "test/vendor/barz-2.0/lib", "test/vendor/baz-1.0/lib"]

  s.add_dependency("wycats-thor", "~> 0.11")
end
