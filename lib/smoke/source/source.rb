module Smoke
  module Source # :nodoc: 
    class Source
    
      attr_reader :items
      
      # Transform each item
      def each(&block)
        @items.each do |item|
          item.instance_eval(&block)
        end
      end
      
      # Permit or restrict
      # def filter
      # end
  
      # Re-sort items
      def sort(key)
        @items = @items.sort_by{|i| i[key] }
      end
      
      private
      def define_items(items)
        @items = items
      end
    end
  end
end