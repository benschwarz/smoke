require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe Hash do
  before :all do
    @item = {:a => "a key", :c => "another key"}
  end
  
  describe "transformations" do
    it "should be renamable" do
      @item.should respond_to(:rename)
    end
    
    it "should have a transform object" do
      @item.rename(:a => :b).should == {:b => "a key", :c => "another key"}
    end
    
    it "should rename many keys" do
      @item.rename(:a => :b, :c => :d).should == {:b => "a key", :d => "another key"}
    end
    
    it "should symbolise string keys" do
      {"a" => {"b" => "bee"}}.symbolize_keys!.should == {:a => {:b => "bee"}}
    end
  end
end
