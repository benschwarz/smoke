require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

module TestSource
  def self.source(name, &block)
    source = Smoke::Origin.allocate
    source.stub!(:dispatch)
    source.send(:define_items, [
      {
        :head => "Platypus"
      },
      {
        :head => "Kangaroo"
      }
    ])
    source.send(:initialize, name, &block)
    return source
  end
end

describe Smoke::Origin do
  before :each do
    @origin = TestSource.source(:test) do
      emit do
        rename(:head => :title)
        sort(:title)
      end
    end
  end
  
  describe "object output" do
    it "should not have a key of head" do
      @origin.output.first.should_not have_key(:head)
    end
  
    it "should be ordered by title" do
      puts @origin.output.inspect
      @origin.output.first.title.should == "Kangaroo"
    end
  end
  
  it "should output" do
    @origin.output.should be_an_instance_of(Array)
  end
end