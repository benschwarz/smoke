require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe Smoke::Cache do
  describe "class methods" do
    it "should respond to configure!" do
      Smoke::Cache.should respond_to(:configure!)
    end
    
    it "should respond to fetch" do
      Smoke::Cache.should respond_to(:fetch)
    end
    
    it "should responsd to enabled?" do
      Smoke::Cache.should respond_to(:enabled?)
    end
  end
  
  describe "configuration" do
    it "should not be enabled (by default)" do
      Smoke::Cache.should_not be_enabled
    end
    
    it "should be enabled" do
      Smoke.configure {|c| c[:cache][:enabled] = true }
      Smoke::Cache.should be_enabled
    end
    
    it "should not be enabled" do
      Smoke.configure {|c| c[:cache][:enabled] = false }
      Smoke::Cache.should_not be_enabled
    end
    
    describe "invalid configuration" do
      before do
        @kernel = mock(Kernel)
        @kernel.stub!(:exit)
      end
      
      it "should log with bad configuration" do
        Proc.new {
          Smoke.should_receive(:log)
          Smoke.configure {|c| c[:cache][:store] = :ponies }
        }
      end
    end
  end
  
  describe "caching my block" do
    before :all do
      Smoke.configure {|c| c[:cache][:store] = :memory }
    end
  end
end