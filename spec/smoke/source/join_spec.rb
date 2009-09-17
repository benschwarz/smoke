require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe "Join" do
  before :all do
    @source_a = TestSource.source :a
    @source_b = TestSource.source :b
    @source_c = TestSource.source :c
  end
  
  describe "joining" do
    before do
      @source = Smoke.join(:a, :b)
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
    
    describe "renaming, within a block" do
      it "should respond to name" do
        Smoke[:a_b_joined].should respond_to(:name)
      end
      
      it "should rename the source" do      
        Smoke.join(:b, :c) do
          name :bee_and_cee
        end
        
        Smoke[:bee_and_cee].should_not be_nil
      end
    end
        
    describe "dispatching" do
      before :all do
        FakeWeb.register_uri("http://photos.tld", :response => File.join(SPEC_DIR, 'supports', 'flickr-photo.json'))

        Smoke.data(:should_dispatch) do
          url "http://photos.tld"
          path :photos, :photo
        end
      end
      
      it "should call dispatch for its children" do
        Smoke[:should_dispatch].should_receive(:dispatch)
        Smoke.join(:a, :should_dispatch).output
      end
      
      it "should call prepare blocks before dispatching" do
        Smoke.data(:prepare_dispatch) do
          prepare do
            url "http://photos.tld"
          end
          
          path :photos, :photo
        end

        Smoke.join(:prepare_dispatch) do
          name :always_be_prepared
        end
        
        lambda { Smoke.always_be_prepared.output }.should_not raise_error(ArgumentError)
      end
    end
    
    describe "variable injection" do
      before :all do
        TestSource.source :variable
        TestSource.source :injection
        Smoke.join(:variable, :injection)
      end
      
      it "should inject variables to its source items" do
        Smoke.variable_injection_joined.some_ivar("value")
        Smoke.variable.some_ivar.should == "value"
      end
    end
  end
end