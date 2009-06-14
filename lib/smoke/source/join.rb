module Smoke
  module Source # :nodoc:
    # The "Joiner" source is a special source
    # that can be used to join multiple sources together
    # and proxy call dispatch for each source
    #
    # Usage:
    #   Smoke.join(:delicious, :twitter, :flickr) do
    #     path :photos, :photo
    #   end
    class Join < Origin # :nodoc: 
      def initialize(names, &block)
        @names = names
        super((names << "joined").join("_").to_sym, &block)
      end
      
      protected
      def sources
        Smoke.active_sources.find_all{|k, v| @names.include?(k) }
      end
      
      def dispatch
        # Recall dispatch
        sources.each do |source|
          source.last.send(:dispatch) if source.last.respond_to?(:dispatch)
        end
        
        # Re-map items
        @items = sources.map {|source| source.last.items }.flatten
      end
    end
  end
end
