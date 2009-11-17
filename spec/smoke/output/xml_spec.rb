require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe Smoke::Output::XML do
  before do
    @tree = :tree
    @items = [
      {:id => 1, :class => "first", :type => "mammal", :animal => "monkey"}, 
      {:id => 2, :class => "second", :type => "mammal", :animal => "elephant"}
    ]
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
    @document.css("item").size.should == 2
  end
end

describe "Smoke XML output with real data" do
  before :all do
    @url = "http://domain.tld/feed.json"
    FakeWeb.register_uri(:get, @url, :response => File.join(SPEC_DIR, 'supports', 'flickr-photo.json'))
    
    Smoke.data :real_xml_output do
      url "http://domain.tld/feed.json", :type => :json
      path :photos, :photo
    end
  end
  
  it "should not error" do
    Smoke.real_xml_output.output(:xml).should include "<?xml"
  end
end