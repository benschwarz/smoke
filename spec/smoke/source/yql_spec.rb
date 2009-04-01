require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe "YQL" do
  before do
    @ruby = Smoke.yql(:ruby) do
      select  :all
      from    "search.web"
      where   :query, "ruby"
    end
  end
  
  it "should be a list of things" do
    @ruby.items.should be_an_instance_of(Array)
  end
  
  it "should hold the url used to query" do
    @ruby.request.uri.should == "http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20search.web%20WHERE%20query%20=%20'ruby'&format=json"
  end
end