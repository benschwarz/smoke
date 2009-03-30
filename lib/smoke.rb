require 'rubygems'
require 'open-uri'
require 'json'

$:<< File.join(File.dirname(__FILE__))

# Core ext
require 'core_ext/hash.rb'

module Smoke
  class << self
    def register(mod)
      class_eval { include mod }
    end
  end
end

require 'smoke/request'
require 'smoke/source'

class Object
  include Smoke
end