class Hash # :nodoc: 
  
  # Thanks merb!
  def symbolize_keys!
    each do |k,v| 
      sym = k.respond_to?(:to_sym) ? k.to_sym : k 
      self[sym] = Hash === v ? v.symbolize_keys! : v 
      delete(k) unless k == sym
    end
    return self
  end
  
  def rename!(candidates)
    candidates.each do |old_key, new_key|
      self[new_key] = self.delete(old_key) if self.has_key?(old_key)
    end
    
    return self
  end
end