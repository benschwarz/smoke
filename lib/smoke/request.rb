module Smoke
  class Request # :nodoc:
    class Failure < Exception # :nodoc:
      attr_reader :uri
      
      def initialize(uri, msg)
        @uri = URI.parse(uri)
        Smoke.log.error "Smoke Request: Failed to get from #{@uri.host} via #{@uri.scheme}\n#{msg}"
      end
    end
    
    SUPPORTED_TYPES = %w(json xml)
    attr_reader :uri, :content_type, :body, :type
       
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
      
      unless @options.include?(:raw_response)
        present!
      end
    rescue OpenURI::HTTPError => e
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
        when :json
          @body = ::Crack::JSON.parse(@body).symbolize_keys!
        when :xml
          @body = ::Crack::XML.parse(@body).symbolize_keys!
        when :unknown
          Smoke.log.warn "Smoke Request: Format unknown for #{@uri} (#{@content_type})"
      end      
    end
  end
end