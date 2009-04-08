require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

module TestSource
  def self.source(name, &block)
    Smoke::Origin.new(name, &block)
  end
end

describe Smoke::Origin do
  before :each do
    @items = [
      {
        :head => "Platypus"
      },
      {
        :head => "Kangaroo"
      }
    ]
    
    stub.any_instance_of(Smoke::Origin).dispatch
    
    @origin = TestSource.source(:test) do
      emit do
        rename(:head => :title)
        sort(:title)
      end
    end
    
    @origin.send(:define_items, @items)
  end
  
  describe "items" do
    it "should not have a key of head"
    it "should be ordered by title"
  end
  
  it "should output" do
    @origin.output.should be_an_instance_of(Array)
  end
end