# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simple-rss}
  s.version = "1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lucas Carlson"]
  s.date = %q{2009-02-25}
  s.description = %q{A simple, flexible, extensible, and liberal RSS and Atom reader for Ruby. It is designed to be backwards compatible with the standard RSS parser, but will never do RSS generation.}
  s.email = %q{lucas@rufy.com}
  s.files = ["lib/simple-rss.rb", "test/base", "test/base/base_test.rb", "test/data", "test/data/atom.xml", "test/data/not-rss.xml", "test/data/rss09.rdf", "test/data/rss20.xml", "test/test_helper.rb", "LICENSE", "Rakefile", "README"]
  s.homepage = %q{http://simple-rss.rubyforge.org/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A simple, flexible, extensible, and liberal RSS and Atom reader for Ruby. It is designed to be backwards compatible with the standard RSS parser, but will never do RSS generation.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
