# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{smoke}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Schwarz"]
  s.date = %q{2009-08-13}
  s.email = %q{ben.schwarz@gmail.com}
  s.extra_rdoc_files = ["README.markdown", "LICENSE"]
  s.files = ["README.markdown", "VERSION.yml", "lib/core_ext", "lib/core_ext/hash.rb", "lib/core_ext/string.rb", "lib/smoke", "lib/smoke/cache.rb", "lib/smoke/origin.rb", "lib/smoke/request.rb", "lib/smoke/source", "lib/smoke/source/data.rb", "lib/smoke/source/feed.rb", "lib/smoke/source/join.rb", "lib/smoke/source/yql.rb", "lib/smoke.rb", "spec/core_ext", "spec/core_ext/hash_spec.rb", "spec/smoke", "spec/smoke/cache_spec.rb", "spec/smoke/origin_spec.rb", "spec/smoke/request_spec.rb", "spec/smoke/shared_spec.rb", "spec/smoke/source", "spec/smoke/source/data_spec.rb", "spec/smoke/source/feed_spec.rb", "spec/smoke/source/join_spec.rb", "spec/smoke/source/yql_spec.rb", "spec/smoke_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/supports", "spec/supports/amc_pacer.json.yql", "spec/supports/datatables.yql", "spec/supports/flickr-photo.json", "spec/supports/gzip_response.txt", "spec/supports/search-web.json.yql", "spec/supports/search-web.xml.yql", "spec/supports/slashdot.xml", "spec/supports/test_source.rb", "LICENSE"]
  s.homepage = %q{http://github.com/benschwarz/smoke}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{smoke is a DSL that allows you to take data from YQL, RSS / Atom}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
