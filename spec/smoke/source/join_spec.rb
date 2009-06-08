require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe "Join" do
  before :all do
    @source_a = TestSource.source :a
    @source_b = TestSource.source :b
    @source_c = TestSource.source :c
  end
  
  describe "joining" do
    before do
      @joined = Smoke.join(:a, :b)
    end
    
    it "should be named in a_b_joined" do
      Smoke[:a_b_joined].should be_an_instance_of(Smoke::Source::Join)
    end
    
    it "should contain items from sources a and b" do
      Smoke[:a_b_joined].output.size.should == (@source_a.output.size + @source_b.output.size)
    end
    
    it "should accept a block" do
      lambda { Smoke.join(:a, :b, :c, Proc.new {}) }.should_not raise_error
    end
    
    it "should allow sorting" do
      Smoke[:a_b_joined].should respond_to(:sort)
    end
    
    it "should allow changes to output" do
      Smoke[:a_b_joined].should respond_to(:output)
    end
        
    describe "renaming" do
      it "should allow renaming" do
        Smoke[:a_b_joined].should respond_to(:rename)
      end
      
      it "should be renamed" do
        Smoke.rename(:a_b_joined => :rename_spec)
        Smoke[:rename_spec].should be_an_instance_of(Smoke::Source::Join)
      end
      
      it "should change its name property after being renamed" do
        Smoke[:rename_spec].name.should == "rename_spec"
      end
    end
  end
end