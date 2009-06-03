module Smoke
  module Source # :nodoc:    
    # The "Data" source allows you to query
    # datasources that are "complete" urls
    # and rely on the automagic object parsing 
    # that smoke provides.
    #
    # For example, you may use this source
    # to query a complete restful api call
    # unpackage the xml response and get a 
    # clean ruby object.
    #
    # Data can take as many urls as you'd like
    # to throw at it.
    #
    # Usage:
    #   Smoke.data(:ruby) do
    #     url "http://api.flickr.com/services/rest/?user_id=36821533%40N00&tags=benschwarz-site&nojsoncallback=1&method=flickr.photos.search&format=json&api_key=your_api_key_here
    #     path :photos, :photo
    #   end
    class Data < Origin
      attr_reader :request
      def self.name; :data; end
            
      def url(source_url)
        @url = source_url
      end
      
      protected
      def dispatch
        @request = Smoke::Request.new(@url)
        self.items = (@path.nil?) ? @request.body : drill(@request.body, *@path)
      end
    end
  end
end
