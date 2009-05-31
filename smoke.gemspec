# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{smoke}
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Schwarz"]
  s.date = %q{2009-05-31}
  s.email = %q{ben.schwarz@gmail.com}
  s.extra_rdoc_files = ["README.markdown", "LICENSE"]
  s.files = ["README.markdown", "VERSION.yml", "lib/core_ext", "lib/core_ext/hash.rb", "lib/smoke", "lib/smoke/delayed_block.rb", "lib/smoke/origin.rb", "lib/smoke/request.rb", "lib/smoke/source", "lib/smoke/source/data.rb", "lib/smoke/source/feed.rb", "lib/smoke/source/yql.rb", "lib/smoke.rb", "spec/core_ext", "spec/core_ext/hash_spec.rb", "spec/smoke", "spec/smoke/origin_spec.rb", "spec/smoke/request_spec.rb", "spec/smoke/source", "spec/smoke/source/data_spec.rb", "spec/smoke/source/feed_spec.rb", "spec/smoke/source/yql_spec.rb", "spec/smoke_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/supports", "spec/supports/flickr-photo.json", "spec/supports/mayo.rb", "spec/supports/search-web.yql", "spec/supports/slashdot.xml", "spec/supports/test_source.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/benschwarz/smoke}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{smoke is a DSL that allows you to take data from YQL, RSS / Atom}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<simple-rss>, ["= 1.2"])
      s.add_runtime_dependency(%q<crack>, ["= 0.1.1"])
    else
      s.add_dependency(%q<simple-rss>, ["= 1.2"])
      s.add_dependency(%q<crack>, ["= 0.1.1"])
    end
  else
    s.add_dependency(%q<simple-rss>, ["= 1.2"])
    s.add_dependency(%q<crack>, ["= 0.1.1"])
  end
end
