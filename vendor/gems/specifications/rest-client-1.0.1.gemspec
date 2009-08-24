# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rest-client}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Wiggins"]
  s.date = %q{2009-06-12}
  s.default_executable = %q{restclient}
  s.description = %q{A simple REST client for Ruby, inspired by the Sinatra microframework style of specifying actions: get, put, post, delete.}
  s.email = %q{adam@heroku.com}
  s.executables = ["restclient"]
  s.files = ["Rakefile", "README.rdoc", "lib/rest_client.rb", "lib/restclient", "lib/restclient/exceptions.rb", "lib/restclient/mixin", "lib/restclient/mixin/response.rb", "lib/restclient/raw_response.rb", "lib/restclient/request.rb", "lib/restclient/resource.rb", "lib/restclient/response.rb", "lib/restclient.rb", "spec/base.rb", "spec/exceptions_spec.rb", "spec/mixin", "spec/mixin/response_spec.rb", "spec/raw_response_spec.rb", "spec/request_spec.rb", "spec/resource_spec.rb", "spec/response_spec.rb", "spec/restclient_spec.rb", "bin/restclient"]
  s.homepage = %q{http://rest-client.heroku.com/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rest-client}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Simple REST client for Ruby, inspired by microframework syntax for specifying actions.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
