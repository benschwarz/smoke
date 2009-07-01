module Smoke
  class Request # :nodoc:
    class Failure < Exception # :nodoc:
      attr_reader :uri
      
      def initialize(uri, msg)
        @uri = URI.parse(uri)
        Smoke.log.error "Smoke Request: Failed to get from #{@uri} (#{msg})"
      end
    end
    
    SUPPORTED_TYPES = %w(json xml javascript)
    attr_reader :uri, :content_type, :body, :type
       
    def initialize(uri, *options)
      @uri, @options = uri, options
      dispatch
    end
    
    private
    def dispatch
      opts = {
        :user_agent       => Smoke.config[:user_agent],
        :accept_encoding  => "gzip"
      }
      Thread.new {
        request = RestClient.get(@uri, opts)
        @content_type = request.headers[:content_type]
        @body = request
      }.join
      
      present! unless @options.include?(:raw_response)
      
    rescue RestClient::Exception => e
      Failure.new(@uri, e)
    end
    
    def present!
      set_type
      parse!
    end
    
    def set_type
      @type = (SUPPORTED_TYPES.detect{|t| @content_type =~ /#{t}/ } || "unknown").to_sym
    end
    
    def parse!
      case @type
        when :json, :javascript
          @body = ::Crack::JSON.parse(@body).symbolize_keys!
        when :xml
          @body = ::Crack::XML.parse(@body).symbolize_keys!
        when :unknown
          Smoke.log.warn "Smoke Request: Format unknown for #{@uri} (#{@content_type})"
      end      
    end
  end
end