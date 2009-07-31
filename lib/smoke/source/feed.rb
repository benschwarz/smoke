module Smoke
  module Source # :nodoc:
    # Feed can take multiple rss or atom feeds and munge them up together.
    # 
    # Usage:
    #   Smoke.feed(:ruby) do
    #     url "domain.tld/rss"
    #     url "site.tld/atom"
    #   end
    class Feed < Origin
      attr_reader :requests
      
      def url(feed_uri)
        (@feeds ||= [] ) << feed_uri
      end
      
      protected
      def dispatch
        @requests = @feeds.map{|f| Smoke::Request.new(f, {:raw_response => true}) }
        self.items = @requests.map{|r| ::SimpleRSS.parse(r.body).items }.flatten
      end
    end
  end
end