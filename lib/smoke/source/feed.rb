gem 'simple-rss', '= 1.2'
require 'simple-rss'

module Smoke
  module Source
    module Feed
      Smoke.register(Smoke::Source::Feed)
      
      def feed(name, &block)
        Feed.new(name, &block)
      end
      
      class Feed < Source
        attr_reader :name, :requests
        
        # Feed can take multiple rss or atom feeds and munge them up together.
        # 
        # Usage:
        #   Smoke.feed(:ruby) do
        #     url "domain.tld/rss"
        #     url "site.tld/atom"
        #   end
        def initialize(name, &block)
          super
        end
        
        def url(feed_uri)
          (@feeds ||= [] ) << feed_uri
        end
        
        private
        def dispatch
          @requests = @feeds.map{|f| Smoke::Request.new(f, :raw_response) }
          define_items @requests.map{|r| ::SimpleRSS.parse(r.body).items }.flatten
        end
      end
    end
  end
end