require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe "YQL" do
  before :all do
    # Fake web does not yet support regex matched uris
    
    FakeWeb.register_uri("query.yahooapis.com/*", :response => File.join(SPEC_DIR, 'supports', 'search-web.yql'))
    
    Smoke.yql(:search) do
      select  :all
      from    "search.web"
      where   :query, "ruby"
      
      emit do
        rename(:url => :link)
      end
    end
  end
  
  it "should have been activated" do
    Smoke[:search].should(be_an_instance_of(Smoke::Source::YQL::YQL))
  end
  
  it "should be a list of things" do
    Smoke[:search].items.should be_an_instance_of(Array)
  end
  
  describe "after dispatch" do
    before do
      Smoke[:search].output
    end
    
    it "should hold the url used to query" do
      Smoke[:search].request.uri.should == "http://query.yahooapis.com/v1/public/yql?format=json&q=SELECT%20*%20FROM%20search.web%20WHERE%20query%20=%20'ruby'"
    end
    
    it "should have renamed url to link" do
      Smoke[:search].output[:result].first.should have_key(:link)
      Smoke[:search].output[:result].first.should_not have_key(:href)
    end

    it "should output a ruby object" do
      Smoke[:search].output[:result].should be_an_instance_of(Array)
    end
  end
  
  describe "yql definitions" do
    before do
      Smoke.yql(:smoke) do
        use "http://datatables.org/alltables.env"

        select :all
        from "github.repo"
        where :id, "benschwarz"
        where :repo, "smoke"
      end
      
      Smoke[:smoke].output # Force execution
    end

    it "should be a respository" do
      Smoke[:smoke].output.should have_key(:repository)
    end

    it "should respond to use" do
      Smoke[:smoke].should respond_to(:use)
    end
    
    it "should contain 'env' within the query string" do
      Smoke[:smoke].request.uri.should =~ /env=/
    end
  end
end