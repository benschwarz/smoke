module Smoke
  module Transformers
    class Ruby < Transformer
      identifier :ruby
    
      def self.generate(tree_name, objects)
        objects
      end
    end
  end
end