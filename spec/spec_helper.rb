require 'rubygems'
gem 'rspec'

require 'spec'
require 'fake_web'


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'smoke'

require 'supports/mayo.rb'