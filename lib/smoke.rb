require 'rubygems'
require 'open-uri'
gem 'json'

$:<< File.join(File.dirname(__FILE__), 'smoke')

require 'request'
require 'sources'

class Object
  include Smoke::Sources
end