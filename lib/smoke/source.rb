Dir["source/*.rb"].each &method(:require)

module Smoke
  class Source
    class << self
      def register(mod)
        class_eval { include mod }
      end
    end
    
    attr_reader :items
    
    # Transform items in some way
    # Not sure how to do this
    def transform(collection, &block)
    end
    
    # Rename properties in each item
    def rename
    end
    
    # Permit or restrict items based on filter results
    def filter
    end
    
    # Re-sort items
    def sort
    end
  end
end