require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe Smoke::Cache do
  describe "class methods" do  
    it "should respond to fetch" do
      Smoke::Cache.should respond_to(:fetch)
    end
    
    it "should respond to enabled?" do
      Smoke::Cache.should respond_to(:enabled?)
    end
    
    it "should respond to clear!" do
      Smoke::Cache.should respond_to(:clear!)
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
  
  describe "caching my request" do
    before :all do
      Smoke.configure do |c| 
        c[:cache][:enabled] = true
        c[:cache][:store] = :memory
      end
      
      @url = "http://memory.tld/store"
      FakeWeb.register_uri(@url, :file => File.join(SPEC_DIR, 'supports', 'slashdot.xml'))
      
      require 'moneta/memory'
      @store = Moneta::Memory.new
      Moneta::Memory.stub!(:new).and_return(@store)
    end
    
    it "should use the moneta::memory store" do
      Moneta::Memory.should_receive(:new).with(Smoke.config[:cache][:options])
      
      Smoke::Cache.fetch @url, {}
    end
        
    it "should try to read from the memory store" do  
      @store.should_receive(:[])
      Smoke::Cache.fetch @url, {}
    end
    
    it "should be stored in the cache" do
      Smoke::Cache.fetch @url, {}
      @store['33af9f13054e64520430f7a437cdd377'].should_not be_nil
    end
    
    it "should be cleared" do
      Smoke::Cache.clear!
      @store['33af9f13054e64520430f7a437cdd377'].should be_nil
    end
  end
end