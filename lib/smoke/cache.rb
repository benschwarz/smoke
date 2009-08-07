require 'moneta'
require 'digest/md5'

module Smoke  
  class << self
    def configure
      @@store = Moneta.const_get(Smoke.config[:cache][:store]).send(:new, Smoke.config[:cache][:options])
    end
    
    def fetch(name, &block)
      key = generate_key(name)
      output = @@store[key]
      if output
        return output
      else
        output = block.call
        persist(key, output)
      end
      
      return output
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