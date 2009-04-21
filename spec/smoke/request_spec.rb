require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe Smoke::Request do
  before do
    @url = "http://fake.tld/canned/"
    @web_search = File.join(SPEC_DIR, 'supports', 'slashdot.xml')
    FakeWeb.register_uri(@url, :file => @web_search)
    @request = Smoke::Request.new(@url)
  end
  
  it "should return a Request object" do
    @request.should be_an_instance_of(Smoke::Request)
  end
  
  it "should have a response body" do
    @request.body.should == File.read(@web_search)
  end
  
  it "should have a content type" do
    @request.content_type.should == 'application/octet-stream'
  end
  
  it "should be a pure ruby array response" do
    # Temporary real request, fakeweb isn't allowing content_type setting as of writing
    @request = Smoke::Request.new("http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20search.web%20WHERE%20query%20=%20'ruby'&format=xml")
    @request.body.should be_an_instance_of(Hash)
  end
  
  it "should be a raw string response" do
    @request = Smoke::Request.new(@url, :raw_response)
    @request.body.should be_an_instance_of(String)
  end
  
  describe "http redirects" do
    it "should follow a redirect to a resource"
    it "should follow only one html redirect before raising an error"
  end
end