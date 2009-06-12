require 'rubygems'
require 'zlib'
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
    @@config = {
      :enable_logging => true,
      :user_agent     => "Ruby/#{RUBY_VERSION}/Smoke"
    }
    
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
        active_sources[o].name = n.to_s
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
      @@log ||= Logger.new(config[:enable_logging] ? $stdout : "/dev/null")
    end
    
    # Set any configurable options
    #
    #     Smoke.configure do |c|
    #       c[:user_agent] = "Some other site"
    #     end
    #
    def configure(&block)
      yield @@config
    end
    
    # Access configuration options
    #
    #   Smoke.config[:option_name]
    #   => true
    def config
      @@config 
    end
    
    def yql(name, &block); Smoke::Source::YQL.new(name, &block); end
    def data(name, &block); Smoke::Source::Data.new(name, &block); end
    def feed(name, &block); Smoke::Source::Feed.new(name, &block); end
    
    # Join multiple sources together into a single feed
    # Usage:
    #   Smoke.join(:delicious, :twitter, :flickr) do
    #     name :stream
    #     path :photos, :photo
    #   end
    def join(*names, &block); Smoke::Source::Join.new(names, &block); end
  end
end

require 'smoke/request'
require 'smoke/origin'

class Object # :nodoc: 
  include Smoke
end