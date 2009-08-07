require 'moneta'
require 'digest/md5'

module Smoke
  class Cache
    class << self
      def configure
        require "moneta/#{Smoke.config[:cache][:store].to_s.downcase}"
        @@store = Moneta.const_get(Smoke.config[:cache][:store]).send(:new, Smoke.config[:cache][:options])
      end
  
      def fetch(name, &block)
        key = generate_key(name)
        output = (enabled?) ? @@store[key] : block.call
        if output
          return output
        else
          output = block.call
          persist(key, output)
        end
    
        return output
      end
  
      def enabled?
        Smoke.config[:cache][:enabled]
      end
  
      private 
      def persist(key, store)
        @@store.store(key, store, :expire_in => Smoke.config[:config][:cache][:expiry])
      end
  
      def generate_key(key)
        Digest::MD5.hexdigest(key)
      end
    end
  end
end