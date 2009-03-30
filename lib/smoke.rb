require 'rubygems'
require 'open-uri'
gem 'json'

# Core ext
require 'core_ext/hash.rb'

$:<< File.join(File.dirname(__FILE__), 'smoke')

module Smoke
  class << self
    def register(mod)
      class_eval { include mod }
    end
  end
end

require 'request'
require 'source'

class Object
  include Smoke
end