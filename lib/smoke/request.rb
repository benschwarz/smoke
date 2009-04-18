module Smoke
  class Request # :nodoc:
    class Failure < Exception # :nodoc:
      attr_reader :uri
      
      def initialize(uri, msg)
        @uri = URI.parse(uri)
        Smoke.log.error "Failed to get from #{@uri.host} via #{@uri.scheme}\n#{msg}"
      end
    end
    
    attr_reader :uri, :content_type, :body
       
    def initialize(uri, *options)
      @uri = uri
      @options = options
      dispatch
    end
    
    private
    def dispatch
      Thread.new {
        open(@uri, "User-Agent" => "Ruby/#{RUBY_VERSION}/Smoke") do |request|
          @content_type = request.content_type
          @body = request.read
        end
      }.join
      
      parse! unless @options.include?(:raw_response)
        
    rescue OpenURI::HTTPError => e
      Failure.new(@uri, e)
    end
    
    def parse!
      case @content_type
      when 'text/json'
        @body = ::Crack::JSON.parse(@body).symbolize_keys!
      when 'text/xml'
        @body = ::Crack::XML.parse(@body).symbolize_keys!
      end
    end
  end
end