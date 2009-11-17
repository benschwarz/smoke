require 'logger'
require 'digest/md5'
require 'yaml'

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
    
    def root
      File.join(File.dirname(__FILE__))
    end
    
    def version
      @@version ||= YAML::load(File.read("#{root}/../VERSION.YML"))
      "#{@@version[:major]}.#{@@version[:minor]}.#{@@version[:patch]}"
    end
    
    # Access registered smoke source instances
    #
    # Define your source:
    #     Smoke.yql(:ruby) do ....
    # Then access it:
    #     Smoke[:ruby]
    #     => #<Smoke::YQL::0x18428d4...
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
    def active_sources; @@active_sources; end
    
    # Returns all exposed sources
    def exposed_sources
      active_sources.reject{|k,v| !v.exposed? }
    end

    # Returns all concealed sources
    def concealed_sources
      active_sources.reject{|k,v| !v.concealed? }
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
    
    def yql(name, &block);  Smoke::YQL.new(name, &block);  end
    def data(name, &block); Smoke::Data.new(name, &block); end
    def feed(name, &block); Smoke::Feed.new(name, &block); end
    
    # Join multiple sources together into a single feed
    # Usage:
    #   Smoke.join(:delicious, :twitter, :flickr) do
    #     name :stream
    #     path :photos, :photo
    #   end
    def join(*names, &block); Smoke::Join.new(names, &block); end
  end
end

# Selectively load everything
Dir["#{File.dirname(__FILE__)}/{core_ext,smoke,smoke/{input,output}}/*.rb"].each {|r| require r}

# Autoload the source classes
%w(YQL Data Feed Join).each do |r|
  Smoke.autoload(r.to_sym, File.join(File.dirname(__FILE__), "smoke", "source", r.downcase))
end

class Object # :nodoc: 
  include Smoke
end