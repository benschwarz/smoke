module Smoke
  class Request # :nodoc:
    class Failure < Exception # :nodoc:
      attr_reader :uri
      
      def initialize(uri, msg)
        @uri = URI.parse(uri)
        super("Failed to get from #{@uri.host} via #{@uri.scheme}\n#{msg}")
      end
    end
    
    attr_reader :uri, :content_type, :body
       
    def initialize(uri)
      @uri = uri
      dispatch
    end
    
    private
    def dispatch
      puts @uri
      open(@uri) do |request|
        @content_type = request.content_type
        @body = request.read
      end
      
      parse!
    rescue OpenURI::HTTPError => e
      Failure.new(@uri, e)
    end
    
    def parse!
      case @content_type
      when 'text/json'
        @body = ::JSON.parse(@body).symbolize_keys!
      end
    end
  end
end