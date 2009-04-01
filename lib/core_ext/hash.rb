class Hash # :nodoc: 
  
  # Thanks merb!
  def symbolize_keys!
    each do |k,v| 
      sym = k.respond_to?(:to_sym) ? k.to_sym : k 
      self[sym] = Hash === v ? v.symbolize_keys! : v 
      delete(k) unless k == sym
    end
    self
  end
  
  class Transform # :nodoc:
    def initialize(hash, key)
      @hash = hash
      @key = key
    end
    
    def to(new_name)
      @hash[new_name] = @hash.delete(@key)
      return @hash
    end
  end
  
  def rename(key)
    Transform.new(self, key)
  end
end