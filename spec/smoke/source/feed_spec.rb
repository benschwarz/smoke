require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe "Feed" do
  before :all do
    FakeWeb.register_uri("http://slashdot.org/index.rdf", :file => File.join(SPEC_DIR, 'supports', 'slashdot.xml'))
    
    Smoke.feed(:slashdot) do
      url "http://slashdot.org/index.rdf"
      url "http://slashdot.org/index.rdf"
      
      emit do
        rename(:link => :url)
      end
    end
  end
  
  
  it "should have been activated" do
    Smoke[:slashdot].should(be_an_instance_of(Smoke::Source::Feed::Feed))
  end
  
  it "should be a list of things" do
    Smoke[:slashdot].items.should be_an_instance_of(Array)
  end
  
  it "should respond to url" do
    Smoke[:slashdot].should respond_to(:url)
  end
  
  it "should accept multiple urls" do
    Smoke[:slashdot].requests.should be_an_instance_of(Array)
  end
  
  it "should hold the url used to query" do
    Smoke[:slashdot].requests.collect{|r| r.uri }.should include("http://slashdot.org/index.rdf")
  end
  
  it "should have renamed url to link" do
    Smoke[:slashdot].items.first.should have_key(:url)
    Smoke[:slashdot].items.first.should_not have_key(:link)
  end
end