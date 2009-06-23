require 'rubygems'
require 'spec'
require 'fake_web'

require File.join(File.dirname(__FILE__), '..', 'lib', 'smoke')

SPEC_DIR = File.dirname(__FILE__) unless defined? SPEC_DIR
$:<< SPEC_DIR

# Don't allow real web requests during specs!
FakeWeb.allow_net_connect = false

require 'supports/test_source.rb'

Smoke.configure do |c|
  c[:enable_logging] = false
end