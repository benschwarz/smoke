require 'logger'
require 'digest/md5'

require 'simple-rss'
require 'json'
require 'crack'
require 'moneta'
require 'restclient'
require 'nokogiri'

module Smoke  
  class << self
    @@active_sources = {}
    @@config = {
      :enable_logging => true,
      :user_agent     => "Ruby/#{RUBY_VERSION}/Smoke",
      :cache          => {
        :enabled  => false,
        :store    => :memory,
        :options  => {},
        :expiry   => 1800
      }
    }
    
    # Access registered smoke source instances
    #
    # Define your source:
    #     Smoke.yql(:ruby) do ....
    # Then access it:
    #     Smoke[:ruby]
    #     => #<Smoke::Source::YQL::0x18428d4...
    def [](source)
      active_sources[source]
    end
    
    # Access registered smoke source instances
    # 
    # Arguments can be sent as key/value pairs to inject abstract properties:
    # Usage:
    #   Smoke.twitter(:username => "benschwarz")
    def method_missing(sym, args = {})
      args.each_pair {|k, v| self[sym].send(k, v) }
      self[sym]
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

%w(core_ext/hash core_ext/string smoke/cache smoke/request smoke/origin smoke/output/xml).each {|r| require File.join(File.dirname(__FILE__), r)}

class Object # :nodoc: 
  include Smoke
end