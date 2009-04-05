require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe Smoke::Request do
  before do
    @url = "http://fake.tld/canned/"
    FakeWeb.register_uri(@url, :string => "canned-data")
    @request = Smoke::Request.new(@url)
  end
  
  it "should return a Request object" do
    @request.should be_an_instance_of(Smoke::Request)
  end
  
  it "should have a response body" do
    @request.body.should == "canned-data"
  end
  
  it "should have a content type" do
    @request.content_type.should == 'application/octet-stream'
  end
  
  it "should be a raw string response" do
    @request = Smoke::Request.new(@url, :raw_response)
    @request.body.should be_an_instance_of(String)
  end
end