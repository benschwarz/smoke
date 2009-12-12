module Smoke
  module Output
    class Json < Generator
      identifier :json
      
      def self.generate(tree_name, objects)
        ::JSON.generate(objects)
      end
    end
  end
end