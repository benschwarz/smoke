require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe "'Data' source" do
  before :all do
    FakeWeb.register_uri("http://photos.tld/index.json", :response => File.join(SPEC_DIR, 'supports', 'flickr-photo.json'))
    
    @source = Smoke.data(:photos) do
      url "http://photos.tld/index.json"
      
      path :photos, :photo
    end
  end
  
  # it_should_behave_like "all sources"
  
  it "should have been activated" do
    Smoke[:photos].should(be_an_instance_of(Smoke::Source::Data))
  end
  
  it "should be a list of things" do
    Smoke[:photos].output.should be_an_instance_of(Array)
  end
  
  it "should respond to url" do
    Smoke[:photos].should respond_to(:url)
  end
  
  it "should hold the url used to query" do
    Smoke[:photos].request.uri.should == "http://photos.tld/index.json"
  end
  
  describe "results" do
    it "should have two items" do
      Smoke[:photos].output.size.should == 2
    end
    
    it "should be photo objects" do
      keys = [:ispublic, :title, :farm, :id, :isfamily, :server, :isfriend, :owner, :secret].each do |key|
        Smoke[:photos].output.first.should(have_key(key))
      end
    end
  end
end