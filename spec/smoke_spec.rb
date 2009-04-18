require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Smoke do
  describe "registration" do
    before do
      Smoke.register(Smoke::SecretSauce) # defined in supports/mayo.rb
    end
    
    it "should allow sources to register themselves" do
      Smoke.included_modules.should include(SecretSauce)
    end
    
    it "should have an instance method of 'mayo'" do
      Smoke.instance_methods.should include("mayo")
    end
  end
  
  describe "joining" do
    before do
      @source_a = TestSource.source :a
      @source_b = TestSource.source :b
      @joined = Smoke.join(:a, :b)
    end
    
    it "should contain items from sources a and b" do
      @joined.output.size.should == (@source_a.output.size + @source_b.output.size)
    end
    
  end
end