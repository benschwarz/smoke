require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe Smoke::Output::XML do
  before do
    @tree = :tree
    @items = [{:animal => "monkey", :mammal => true}, {:animal => "elephant"}]
    @xml = Smoke::Output::XML.generate(@tree, @items)
    @document = Nokogiri::XML(@xml)
  end
  
  it "should respond to generate" do
    Smoke::Output::XML.should respond_to(:generate)
  end
  
  it "should start the tree off with a named key" do
    @document.css("tree").should_not be_nil
  end
  
  it "should contain items" do
    @document.css("items").each do |item|
      item.content.should =~ /monkey/
    end
  end
end