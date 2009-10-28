require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Smoke do
  before :all do
    @source_a = TestSource.source :a
    @source_b = TestSource.source :b
  end
  
  describe "active sources" do
    it "should allow access to sources via an array accessor" do
      Smoke[:a].should == @source_a
    end
    
    it "should be a hash" do
      Smoke.active_sources.should be_an_instance_of(Hash)
    end
    
    it "should have its name as the hash key" do
      key = Smoke.active_sources.keys.first
      Smoke.active_sources[key].name.should == key
    end
    
    describe "accessing via method call" do
      it "should allow access to the sources via a method call" do
        Smoke.a.should == @source_a 
      end
      
      it "should throw an argument error when missing" do
        Smoke.b.should raise_error(NoMethodError)
      end
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
  
  describe "exposed and concealed" do
    before :all do
      TestSource.source :exposed_by_default
      
      TestSource.source :exposed do
        expose
      end
      
      TestSource.source :concealed do
        conceal
      end
    end
    
    describe "exposed_sources" do
      it "should be a hash" do
        Smoke.exposed_sources.should be_an_instance_of(Hash)
      end
      
      it "should be exposed sources only" do
        Smoke.exposed_sources.values.should_not include(Smoke.concealed)
      end
    end
    
    describe "concealed_sources" do
      it "should be a hash" do
        Smoke.concealed_sources.should be_an_instance_of(Hash)
      end
      
      it "should be concealed sources only" do
        Smoke.concealed_sources.values.should_not include(Smoke.exposed)
      end
    end
  end
end