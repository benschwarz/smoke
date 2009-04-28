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
    
    @@active_sources = {}
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
    
    # Access registered smoke source instances
    #
    # Usage:
    #
    #     Smoke.yql(:ruby) do ....
    #
    #     Smoke[:ruby]
    #     => #<Smoke::Source::YQL::YQL:0x18428d4...
    def [](source)
      active_sources[source]
    end
    
    def join(*sources, &block)
      @items = get_sources(sources).map {|source| source[1].items }.flatten
      
      joined_name = (sources << "joined").join("_").to_sym
      source = Origin.new(joined_name, &block)

      source.items = @items
      return source
    end
    
    def activate(name, source)
      if active_sources.has_key?(name)
        Smoke.log.warn "Smoke source activation: Source with idential name already initialized" 
      end
      
      active_sources.update({ name => source })
    end
    
    # Returns all activated smoke sources
    def active_sources
      @@active_sources
    end
    
    # Rename a source 
    def rename(candidates)
      candidates.each do |o, n| 
        active_sources[o].rename(o => n)
        return active_sources[n]
      end
    end
    
    # Log for info, debug, error and warn with:
    # 
    #   Smoke.log.info "message"
    #   Smoke.log.debug "message"
    #   Smoke.log.error "message"
    #   Smoke.log.warn "message"
    def log
      @logger ||= Logger.new($stdout)
    end
    
    private
    def get_sources(sources = [])
      active_sources.find_all{|k, v| sources.include?(k) }
    end
  end
end

require 'smoke/request'
require 'smoke/origin'
require 'smoke/delayed_block'

class Object # :nodoc: 
  include Smoke
end