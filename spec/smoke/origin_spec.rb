require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe Smoke::Origin do
  before do
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
  end
  
  describe "transformations" do
    it "should rename properties" do
      Smoke[:test].rename(:title => :header).output.first.should have_key(:header)
    end
    
    it "should sort by a given property" do
      Smoke[:test].sort(:title).output.first[:title].should == "Kangaroo"
    end
    
    it "should truncate results given a length" do
      Smoke[:test].truncate(1).output.size.should == 1
    end
    
    describe "filtering" do
      it "should accept items that match"
      it "should deny items that match"
    end
  end
  
  it "should output" do
    @origin.output.should be_an_instance_of(Array)
  end
  
  it "should output two items" do
    @origin.output.size.should == 2
  end
  
  it "should output json" do
    @origin.output(:json).should =~ /^\[\{/
  end
  
  it "method chaining" do
    @source = TestSource.source(:chain)
    @source.rename(:head => :header).sort(:header).output.should == [{:header => "Kangaroo"}, {:header => "Platypus"}]
  end
  
  it "should softly error when attempting to sort on a key that doesn't exist" do
    TestSource.source(:chain).sort(:header).should_not raise_error("NoMethodError")
  end
end