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
    
    # Access registered smoke source instances
    #
    # Usage:
    #
    #     Smoke.yql(:ruby) do ....
    #
    #     Smoke[:ruby]
    #     => #<Smoke::Source::YQL::0x18428d4...
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
    
    # Activates new instances of sources
    # Source instances are stored within the 
    # @@active_sources class variable for later use
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
        active_sources.rename(o => n)
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
      @@log ||= Logger.new($stdout)
    end
    
    def yql(name, &block); Smoke::Source::YQL.new(name, &block); end
    def data(name, &block); Smoke::Source::Data.new(name, &block); end
    def feed(name, &block); Smoke::Source::Feed.new(name, &block); end
    
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