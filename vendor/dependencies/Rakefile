task :test do
  system "cd test && env GEM_HOME=#{File.expand_path("tmp")} ruby dependencies_test.rb"
end

task :default => :test
