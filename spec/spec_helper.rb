require 'rubygems'
gem 'rspec'

require 'spec'
require 'fake_web'

$:<< File.join(File.dirname(__FILE__), '..', 'lib')

SPEC_DIR = File.dirname(__FILE__)
$:<< SPEC_DIR

require 'smoke'

require 'supports/mayo.rb'