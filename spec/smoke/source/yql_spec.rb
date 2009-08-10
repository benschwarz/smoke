require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe "YQL" do
  before :all do
    FakeWeb.register_uri("http://query.yahooapis.com:80/v1/public/yql?q=SELECT%20*%20FROM%20search.web%20WHERE%20query%20=%20'ruby'&format=json", :response => File.join(SPEC_DIR, 'supports', 'search-web.json.yql'))
    
    @source = Smoke.yql(:search) do
      select  :all
      from    "search.web"
      where   :query, "ruby"
      path    :query, :results, :result
      
      emit do
        rename(:url => :link)
      end
    end
  end
  
  # it_should_behave_like "all sources"
  
  it "should have been activated" do
    Smoke[:search].should(be_an_instance_of(Smoke::Source::YQL))
  end
  
  it "should be a list of things" do
    Smoke[:search].items.should be_an_instance_of(Array)
  end
  
  describe "select" do
    before do
      FakeWeb.register_uri("http://query.yahooapis.com:80/v1/public/yql?q=SELECT%20url%20FROM%20search.images%20WHERE%20query%20=%20'amc%20pacer'&format=json", :response => File.join(SPEC_DIR, 'supports', 'amc_pacer.json.yql'))
      
      Smoke.yql(:pacer) do
        select :url
        from "search.images"
        where :query, "amc pacer"
        
        path :query, :results, :result
      end
      
      Smoke[:pacer].output
    end
    
    it "should query correctly" do
      Smoke[:pacer].request.uri.should == "http://query.yahooapis.com/v1/public/yql?q=SELECT%20url%20FROM%20search.images%20WHERE%20query%20=%20'amc%20pacer'&format=json"
    end
    
    it "should have urls" do
      Smoke[:pacer].output.first.should have_key(:url)
    end
  end
  
  describe "after dispatch" do
    before do
     Smoke[:search].output
    end
    
    describe "url" do
      it "should contain the base uri for yql" do
        Smoke[:search].request.uri.should =~ /^http:\/\/query.yahooapis.com\/v1\/public\/yql?/
      end
      
      it "should be format=json" do
        Smoke[:search].request.uri.should include("format=json")
      end
      
      it "should contain the query" do
        Smoke[:search].request.uri.should include("SELECT%20*%20FROM%20search.web%20WHERE%20query%20=%20'ruby'")
      end
    end
    
    it "should have renamed url to link" do
      Smoke[:search].output.first.should have_key(:link)
      Smoke[:search].output.first.should_not have_key(:url)
    end

    it "should output a ruby object" do
      Smoke[:search].output.should be_an_instance_of(Array)
    end
  end
  
  describe "yql definitions" do
    before do
      FakeWeb.register_uri("http://query.yahooapis.com:80/v1/public/yql?q=SELECT%20*%20FROM%20github.repo%20WHERE%20id%20=%20'benschwarz'%20AND%20repo%20=%20'smoke'&format=json&env=http://datatables.org/alltables.env", :response => File.join(SPEC_DIR, 'supports', 'datatables.yql'))
      
      Smoke.yql(:smoke) do
        use "http://datatables.org/alltables.env"

        select :all
        from "github.repo"
        where :id, "benschwarz"
        where :repo, "smoke"
        path :query, :results
      end
      
      Smoke[:smoke].output # Force execution
    end

    it "should be a respository" do
      Smoke[:smoke].output.first.should have_key(:repository)
    end

    it "should respond to use" do
      Smoke[:smoke].should respond_to(:use)
    end
    
    it "should contain 'env' within the query string" do
      Smoke[:smoke].request.uri.should =~ /env=/
    end
  end
end