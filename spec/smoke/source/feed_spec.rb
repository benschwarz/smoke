require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe "Feed" do
  before do
    FakeWeb.register_uri("http://slashdot.org/index.rdf", :file => File.join(SPEC_DIR, 'supports', 'slashdot.feed'))
    
    @rss = Smoke.feed(:ruby) do
      url "http://slashdot.org/index.rdf"
      url "http://slashdot.org/index.rdf"
      
      emit do
        rename(:link => :url)
      end
    end
  end
  
  it "should be a list of things" do
    @rss.items.should be_an_instance_of(Array)
  end
  
  it "should accept multiple urls" do
    @rss.requests.should be_an_instance_of(Array)
  end
  
  it "should hold the url used to query" do
    @rss.requests.collect{|r| r.uri }.should include("http://slashdot.org/index.rdf")
  end
  
  it "should have renamed url to link" do
    @rss.items.first.should have_key(:url)
    @rss.items.first.should_not have_key(:link)
  end
end