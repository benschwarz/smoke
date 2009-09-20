module Smoke
  module Output
    class XML
      def self.generate(tree_name, items)
        builder = Nokogiri::XML::Builder.new do |xml|
            xml.send(tree_name) {
              xml.items {
                items.each do |item|
                  xml.item {
                    item.each_pair do |key, value|
                      xml.send(key, value)
                    end
                  }
                end
              }
            }
        end
        
        builder.to_xml
      end
    end
  end
end