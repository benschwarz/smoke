module Smoke
  class Cache
    class << self
      def fetch(uri, options)  
        output = (enabled?) ? read(uri) : query(uri, options)
        
        unless output.keys.any?
          Smoke.log.info "Cache miss"
          output = query(uri, options)
        end
        
        output
      rescue
        query(uri, options)
      end

      def enabled?
        Smoke.config[:cache][:enabled]
      end
    
      # Clear all your request caches
      def clear!
        cache.clear
      end
  
      protected
      def cache
        Moneta.autoload(klass_name.to_sym, file_name)
        @@cache ||= Moneta.const_get(klass_name).new(Smoke.config[:cache][:options])
      end
            
      def file_name
        "moneta/#{Smoke.config[:cache][:store].to_s}"
      end
      
      def klass_name
        Smoke.config[:cache][:store].to_s.camel_case
      end
      
      def query(uri, options)
        request = RestClient.get(uri, options)
        write(uri, request, request.headers[:content_type]) if enabled?
        {:body => request, :content_type => request.headers[:content_type]}
      end
      
      def read(uri)
        key = generate_key(uri)
        return cache[key]
      end
      
      def write(uri, body, content_type)
        store = {:body => body, :content_type => content_type}
        self.cache.store(generate_key(uri), store, :expire_in => Smoke.config[:cache][:expiry])
      end
  
      def generate_key(key)
        Digest::MD5.hexdigest(key.to_s)
      end
    end
  end
end