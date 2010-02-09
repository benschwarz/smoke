require 'rubygems'
require 'rake'
require 'spec'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "smoke"
    gem.summary = %Q{smoke is a Ruby based DSL that allows you to query web services such as YQL, RSS / Atom and JSON or XML in an elegant manner.}
    gem.email = "ben.schwarz@gmail.com"
    gem.homepage = "http://github.com/benschwarz/smoke"
    gem.authors = ["Ben Schwarz"]
    gem.files = FileList['lib/**/*.rb', 'rdoc/**/*', '[A-Z]*', 'spec/**/*', 'vendor/**/*'].to_a
    gem.add_development_dependency("fakeweb", ">= 1.2.5")
    gem.add_dependency("simple-rss", "1.2")
    gem.add_dependency("json", ">= 1.1.3")
    gem.add_dependency("crack", ">= 0.1.1")
    gem.add_dependency("moneta", "0.6.0")
    gem.add_dependency("rest-client", "1.0.3")
    gem.add_dependency("nokogiri", "1.3.2")
    gem.add_dependency("registry", ">=0.1.2")
    gem.add_dependency("fastercsv", ">=1.5.1")
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

begin
  gem 'mislav-hanna', '>= 0.2.7'
  require 'hanna/rdoctask'
rescue LoadError
  require 'rake/rdoctask'
end
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'smoke'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:test) do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :test
task :default => :test
