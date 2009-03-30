require 'rubygems'
require 'open-uri'
gem 'json'

# Core ext
require 'core_ext/hash.rb'

$:<< File.join(File.dirname(__FILE__), 'smoke')

require 'request'
require 'source'

class Object
  include Smoke::Source
end