module Smoke
  module Source
    class Source
    
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
      
      # Transform each item
      def each(&block)
      end
    end
  end
end