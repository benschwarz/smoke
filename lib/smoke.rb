require 'rubygems'
require 'open-uri'
require 'logger'

$:<< File.join(File.dirname(__FILE__))

# Core ext
require 'core_ext/hash.rb'

module Smoke
  class << self
    
    @@active_sources = []
    attr_reader :active_sources
    
    # Smoke sources can register themselves
    # via the register method:
    #   Smoke.register(Smoke::Source::YQL)
    def register(mod)
      class_eval { include mod }
    end
    
    def join(sources = [])
      @items = get_sources.map {|source| source[1] }
      
    end
    
    def activate(name, source)
      @@active_sources << {name => source}
    end
    
    def active_sources
      @@active_sources
    end
    
    def log
      @logger ||= Logger.new($stdout)
    end
    
    private
    def get_sources(sources = [])
      active_sources.find_all{|k,v| sources.include?(k) }
    end
  end
end

require 'smoke/request'
require 'smoke/source'
require 'smoke/delayed_block'

class Object # :nodoc: 
  include Smoke
end