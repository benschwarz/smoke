require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe Smoke::Request do
  before do
    @url = "http://fake.tld/canned/"
    @web_search = File.join(SPEC_DIR, 'supports', 'flickr-photo.json')
    FakeWeb.register_uri(@url, :response => @web_search)
    @request = Smoke::Request.new(@url)
  end
  
  it "should return a Request object" do
    @request.should be_an_instance_of(Smoke::Request)
  end
    
  it "should have a content type" do
    @request.content_type.should =~ /text\/json/
  end
  
  it "should be a raw string response" do
    request = Smoke::Request.new(@url, :raw_response)
    request.body.should == "{\"photos\":{\"page\":1, \"pages\":1, \"perpage\":100, \"total\":\"2\", \"photo\":[{\"id\":\"3443335843\", \"owner\":\"36821533@N00\", \"secret\":\"5a15f0bfb9\", \"server\":\"3305\", \"farm\":4, \"title\":\"How I roll\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"3345220961\", \"owner\":\"36821533@N00\", \"secret\":\"a1dd2b9eca\", \"server\":\"3581\", \"farm\":4, \"title\":\"My desk\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}]}, \"stat\":\"ok\"}"
  end
  
  describe "gzipped responses" do
    before do
      # Gzip response should come out exactly the same as the plain text response
      @gzip_response = File.join(SPEC_DIR, 'supports', 'gzip_response.txt')
      @url = "http://fake.tld/gzip"
      FakeWeb.register_uri(@url, :response => @gzip_response, :content_encoding => "gzip")
    end
    
    it "should transparently handle a gzipped response" do
      request = Smoke::Request.new(@url)
      request.body.should == "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n\t\"http://www.w3.org/TR/html4/strict.dtd\">\n<html>\n\t<head>\n\t\t<title>New street represent</title>\n\t\t<style type=\"text/css\" media=\"screen\">\n\t\t\tbody {\n\t\t\t\tfont-family: helvetica, arial, sans-serif;\n\t\t\t\tfont-size: 2em;\n\t\t\t\tbackground-color: black;\n\t\t\t\tletter-spacing: -3px;\n\t\t\t\tmargin: 0 auto;\n\t\t\t}\n\t\t\th1 {\n\t\t\t\tposition: absolute;\n\t\t\t\tright: 0;\n\t\t\t\tbackground-color: #666;\n\t\t\t\twidth: 4em;\n\t\t\t}\n\t\t</style>\n\t</head>\n\t<body>\n\t\t<h1>Massive</h1>\n\t</body>\n</html>"
    end
  end
end