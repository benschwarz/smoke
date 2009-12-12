module Smoke
  module Transformers
      class XML < Transformer
      identifier :xml
    
      def self.generate(tree_name, items)
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.items {
            items.each do |item|
              xml.item {
                %w(id type class).each{|m| item["#{m}_".to_sym] = item.delete(m.to_sym) }
              
                item.each do |k, v|
                  xml.send(k, v)
                end
              }
            end
          }
        end
      
        builder.to_xml
      end
    end
    
    def self.parse(string)
      ::Crack::XML.parse(string)
    end
  end
end