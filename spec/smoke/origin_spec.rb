require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe Smoke::Origin do
  before :each do
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
      @origin.output.first.title.should == "Kangaroo"
    end
  end
  
  it "should output" do
    @origin.output.should be_an_instance_of(Array)
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