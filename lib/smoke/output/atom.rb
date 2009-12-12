require 'time' # for ISO8601
module Smoke
  module Output
    class Atom
      def self.generate(tree_name, items)
        instance_eval &block if block_given?
        
        builder = Nokogiri::XML::Builder.new do |atom|
          atom.feed(:xmlns => "http://www.w3.org/2005/Atom") {
            atom.title tree_name
            # link (self)
            # link
            atom._id "UUID"
            atom.updated "TIMESTAMP"
            atom.author {
              atom.name "Name"
              atom.email "Email"
            }
            atom.generator(:uri => "http://github.com/benschwarz/smoke", :version => Smoke.version){"Smoke"} 
            
            items.each do |item|
              atom.entry {
                atom._id "url to post"
                atom.title item[:title]
                atom.updated item.published.iso8601 rescue nil
              }
            end            
          }
        end
        builder.to_xml
        
      end  
    end
  end
end
      