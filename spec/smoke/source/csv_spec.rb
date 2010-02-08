require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe "CSV" do
  before :all do
    FakeWeb.register_uri(:get, "http://www.asx.com.au/asx/research/ASXListedCompanies.csv", :body => File.join(SPEC_DIR, 'supports', 'ASXListedCompanies.csv'))
    
    @source = Smoke.csv(:asx_companies) do
      url "http://www.asx.com.au/asx/research/ASXListedCompanies.csv", :header_row => 3
    end
  end
  
  # it_should_behave_like "all sources"
  
  it "should have been activated" do
    Smoke[:asx_companies].should(be_an_instance_of(Smoke::CSV))
  end
  
  it "should be a list of things" do
    Smoke[:asx_companies].items.should be_an_instance_of(Array)
  end
  
  it "should respond to url" do
    Smoke[:asx_companies].should respond_to(:url)
  end
  
  describe "after dispatch / query" do
    before do
      Smoke[:asx_companies].output
    end
    
    it "should hold the url used to query" do
      Smoke[:asx_companies].request.uri.should include("http://www.asx.com.au/asx/research/ASXListedCompanies.csv")
    end
    
  end
end