module Smoke
  module Transformers
    class Json < Transformer
      identifier :json
    
      def self.generate(tree_name, objects)
        ::JSON.generate(objects)
      end
      
      def self.parse(string)
        ::Crack::JSON.parse(string)
      end
    end
  end
end