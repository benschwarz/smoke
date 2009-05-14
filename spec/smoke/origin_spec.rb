require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe Smoke::Origin do
  before :all do
    @origin = TestSource.source(:test) do
      emit do
        rename(:head => :title)
        sort(:title)
      end
    end
  end
  
  describe "after emit, object output" do
    it "should not have a key of head" do
      @origin.output.first.should_not have_key(:head)
    end
  
    it "should be ordered by title" do
      @origin.output.first[:title].should == "Kangaroo"
    end
    
    it "should output a single hash rather than a hash in an array when there is one item" do
      Smoke[:test].truncate(1).output.should == {:title => "Kangaroo"}
    end
  end
  
  describe "transformations" do
    it "should rename properties" do
      Smoke[:test].rename(:title => :header).output.first.should have_key(:header)
    end
    
    it "should sort by a given property" do
      Smoke[:test].sort(:header).output.first[:header].should == "Kangaroo"
    end
    
    it "should truncate results given a length" do
      Smoke[:test].truncate(1).output.size.should == 1
    end
    
    describe "filtering" do
      before do
        TestSource.source(:keep)
        TestSource.source(:discard)
      end
      
      it "should keep items" do
        Smoke[:keep].should(respond_to(:keep))
      end
      
      it "should only contain items that match" do
        Smoke[:keep].keep(:head, /^K/).output.should == {:head => "Kangaroo"}
      end
      
      it "should discard items" do
        Smoke[:discard].should(respond_to(:discard))
      end
      
      it "should not contain items that match" do
        Smoke[:discard].discard(:head, /^K/).output.should == {:head => "Platypus"}
      end
    end
  end
  
  describe "output" do
    it "should output" do
      @origin.output.should be_an_instance_of(Array)
    end

    it "should output two items" do
      @origin.output.size.should == 2
    end

    it "should output json" do
      @origin.output(:json).should =~ /^\[\{/
    end

    it "should output yml" do
      @origin.output(:yaml).should =~ /--- \n- :title:/
    end
    
    it "should dispatch when output is called" do
      TestSource.source(:no_dispatch)
      Smoke[:no_dispatch].should_not_receive(:dispatch)

      TestSource.source(:dispatch)
      Smoke[:dispatch].should_receive(:dispatch)
      Smoke[:dispatch].output
    end
  end
  
  it "method chaining" do
    @source = TestSource.source(:chain)
    @source.rename(:head => :header).sort(:header).output.should == [{:header => "Kangaroo"}, {:header => "Platypus"}]
  end
  
  it "should softly error when attempting to sort on a key that doesn't exist" do
    TestSource.source(:chain).sort(:header).should_not raise_error("NoMethodError")
  end
end