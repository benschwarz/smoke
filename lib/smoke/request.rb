module Smoke
  class Request     
    class Failure < Exception
      attr_reader :uri
      
      def initialize(uri)
        @uri = URI.parse(uri).host
        super("Failed to get from #{@uri.host} via #{@uri.scheme}")
      end
    end
    
    attr_reader :uri, :content_type, :body
       
    def initialize(uri)
      @uri = uri
      dispatch
    end
    
    private
    def dispatch

      open(@uri) do |request|
        @content_type = request.content_type
        @body = request.read
      end
      
      return parse
    end
    
    def parse
      case @content_type
      when 'application/json'
        JSON.parse(@body)
      else
        return @body
      end
    end
  end
end