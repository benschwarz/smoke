module Smoke
  module Output
    class Yaml < Generator
      identifier :yml, :yaml
      
      def self.generate(tree_name, objects)
        YAML.dump(objects)
      end
    end
  end
end