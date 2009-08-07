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
      
      # The URL that you'd like smoke to source its data from
      # You can also set the type for silly servers that don't set a correct content-type (Flickr!)
      # Example:
      #   url "http://site.com/resource.json", :type => :json
      def url(source_url, options = {})
        @url, @options = source_url, options
      end
      
      protected
      def dispatch          
        @request = Smoke::Request.new(@url, @options)
        self.items = @request.body
      end
    end
  end
end
