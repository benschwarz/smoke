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
end