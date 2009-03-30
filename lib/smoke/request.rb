module Smoke
  class Request     
    class Failure < Exception
      attr_reader :uri
      
      def initialize(uri)
        @uri = URI.parse(uri).host
        super("Failed to get from #{@uri.host} via #{@uri.scheme}")
      end
    end
    
    attr_reader :uri, :response
       
    def initialize(uri)
      @uri = uri
      dispatch
    end
    
    private
    def dispatch
      response = {}
      
      open(@uri) do |request|
        response[:content_type] = request['Content-Type']
        response[:body] = request.read
      end
      
      return parse(response)
    end
    
    def parse(response)
      case response[:content_type]
      when 'application/json'
        JSON.parse(response[:body])
      else
        return response[:body]
      end
    end
  end
end