require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Smoke do
  before :all do
    @source_a = TestSource.source :a
    @source_b = TestSource.source :b
  end
  
  describe "active sources" do
    it "should allow access to sources via an array accessor" do
      Smoke[:a].should be_an_instance_of(Smoke::Origin)
    end
    
    it "should be able to be renamed" do
      Smoke.rename(:a => :b)
      Smoke[:a].should be_nil
      Smoke[:b].should be_an_instance_of(Smoke::Origin)
    end
  end
end