require 'rubygems'
require 'rake'
require 'spec'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "smoke"
    gem.summary = %Q{TODO}
    gem.email = "ben.schwarz@gmail.com"
    gem.homepage = "http://github.com/benschwarz/smoke"
    gem.authors = ["Ben Schwarz"]
    gem.add_dependency("simple-rss", "= 1.2")
    gem.add_dependency("crack", "= 0.1.1")
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'hanna/rdoctask'
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

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :default => :test
