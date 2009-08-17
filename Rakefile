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
    gem.files = FileList['dependencies', 'lib/**/*.rb', 'rdoc/**/*', '[A-Z]*', 'spec/**/*', 'vendor/**/*'].to_a
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
