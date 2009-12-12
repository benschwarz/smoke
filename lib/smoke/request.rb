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
    @@request_options = {
      :user_agent       => Smoke.config[:user_agent],
      :accept_encoding  => "gzip, deflate"
    }
    
    attr_reader :uri, :content_type, :body
       
    def initialize(uri, options = {})
      @uri, @options = uri, options
      dispatch
    end
    
    def type
      @type ||= @options[:type] || (SUPPORTED_TYPES.detect{|t| @content_type =~ /#{t}/ } || "unknown").to_sym
    end
    
    private
    def dispatch
      get = Smoke::Cache.fetch @uri, @@request_options
      @body = get[:body]
      @content_type = get[:headers][:content_type]
      
      parse! unless @options[:raw_response]
      
    rescue RestClient::Exception => e
      Failure.new(@uri, e)
    end
    
    def parse!
      @body = Transformer.for(type).parse(body).symbolize_keys!
    rescue Registry::NotRegistered
      Smoke.log.warn "Smoke Request: Format unknown for #{@uri} (#{@content_type})"
    end
  end
end