module Smoke
  module Output
    class Ruby < Generator
      identifier :ruby
      
      def self.generate(tree_name, objects)
        objects
      end
    end
  end
end