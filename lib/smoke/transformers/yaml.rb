module Smoke
  module Transformers
    class Yaml < Transformer
      identifier :yml, :yaml
    
      def self.generate(tree_name, objects)
        YAML.dump(objects)
      end
    end
  end
end