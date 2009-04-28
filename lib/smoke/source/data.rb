module Smoke
  module Source # :nodoc:
    module Data # :nodoc:
      Smoke.register(Smoke::Source::Data)
      
      def data(name, &block)
        Data.new(name, &block)
      end
      
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
        
        def url(source_url)
          @url = source_url
        end
        
        # Path allows you to traverse the tree of a the items returned to 
        # only give you access to what you're interested in. In the case
        # of the comments in this document I traverse to the photos returned.
        def path(*path)
          @path = path
        end
        
        protected
        def dispatch
          @request = Smoke::Request.new(@url)
          self.items = (@path.nil?) ? @request.body : drill(@request.body, *@path)
        end
        
        private
        def drill(*path)
          path.inject(nil) do |obj, pointer|
            obj = obj.nil? ? pointer : obj[pointer]
          end
        end
      end
    end
  end
end
