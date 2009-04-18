require 'rubygems'
require 'open-uri'
require 'logger'
require 'json'
require 'crack'
require 'simple-rss'


$:<< File.join(File.dirname(__FILE__))

# Core ext
require 'core_ext/hash.rb'

module Smoke
  class << self
    
    @@active_sources = []
    attr_reader :active_sources
    
    # Smoke sources can invoke access to themselves
    # via the register method:
    #
    #   Smoke.register(Smoke::Source::YQL)
    #
    # Check the supplied sources for usage
    def register(mod)
      class_eval { include mod }
    end
    
    def join(*sources)
      @items = get_sources(sources).map {|source| source[1] }
      joined_name = (sources << "joined").join("_").to_sym
      Smoke::Origin.new(joined_name)
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
require 'smoke/origin'
require 'smoke/delayed_block'

class Object # :nodoc: 
  include Smoke
end