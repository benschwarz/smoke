require 'rubygems'
require 'open-uri'
require 'json'

$:<< File.join(File.dirname(__FILE__))

# Core ext
require 'core_ext/hash.rb'

module Smoke
  class << self
    # Smoke sources can register themselves
    # via the register method:
    #   Smoke.register(Smoke::Source::YQL)
    def register(mod)
      class_eval { include mod }
    end
  end
end

require 'smoke/request'
require 'smoke/source'
require 'smoke/item'

class Object # :nodoc: 
  include Smoke
end