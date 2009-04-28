require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Smoke do
  before do
    @source_a = TestSource.source :a
    @source_b = TestSource.source :b
    @source_c = TestSource.source :c
  end
  
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
      @joined = Smoke.join(:a, :b)
    end
    
    it "should contain items from sources a and b" do
      @joined.output.size.should == (@source_a.output.size + @source_b.output.size)
    end
    
    it "should accept a block" do
      lambda { Smoke.join(:a, :b, Proc.new {}) }.should_not raise_error
    end
    
    it "should allow sorting" do
      Smoke.join(:a, :b).should respond_to(:sort)
    end
    
    it "should allow renaming" do
      Smoke.join(:a, :b).should respond_to(:rename)
    end
    
    it "should allow changes to output" do
      Smoke.join(:a, :b).should respond_to(:output)
    end
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