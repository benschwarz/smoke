module Smoke
  module Source # :nodoc: 
    class Source
      
      attr_reader :items  
      
      def initialize(name, &block)
        @name = name
        
        if block_given?
          self.instance_eval(&block)
          dispatch
          activate!
        end
      end
      
      def inspect # :nodoc:
        "A Smoke Source - :#{name.to_sym}"
      end
      
      # Transform each item
      #
      # Usage:
      #   emit do
      #     rename(:href => :link)
      #   end 
      def emit(&block)
        (@transformations ||= []) << DelayedBlock.new(&block)
      end
  
      # Re-sort items
      def sort(key)
        @items = @items.sort_by{|i| i[key] }
      end
      
      # Rename one or many keys at a time
      # Suggested that you run it within an each block, but it makes no difference
      # other than readability
      #
      # Usage
      #   # Renames all items with a key of href to link
      #   rename(:href => :link)
      # or
      #   rename(:href => :link, :description => :excerpt)
      def rename(*args)
        @items.each {|item| item.rename(*args)  }
      end
      
      private

      def define_items(items)
        @items = items.map{|i| i.symbolize_keys! }
        invoke_transformations
      end
      
      def invoke_transformations
        @transformations.each{|t| t.execute! } unless @transformations.nil?
      end
      
      def activate!
        Smoke.activate(name, self)
      end
    end
  end
end