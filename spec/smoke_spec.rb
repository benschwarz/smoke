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

    it "should change its name property after being renamed" do
      Smoke[:b].name.should == "b"
    end
  end
  
  describe "configuration" do
    it "should be configurable" do
      Smoke.should respond_to(:configure)
    end
    
    it "should be accessible" do
      Smoke.should respond_to(:config)
    end
    
    it "should take a block and be retrievable" do
      Smoke.configure {|c| c[:spec] = true }
      Smoke.config[:spec].should be_true
    end
    
    describe "default configurations" do
      it "should have at least one default configuration" do
        Smoke.config.keys.should_not be_empty
      end

      it "should allow overwriting default configurations" do
        key = :user_agent
        Smoke.configure {|c| c[key] = "Smoke, dude" }
        Smoke.config[key].should == "Smoke, dude"
      end
    end
  end
end