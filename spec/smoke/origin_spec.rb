require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe Smoke::Origin do
  before :all do
    @origin = TestSource.source(:test) do
      emit do
        rename(:head => :title)
        sort(:title)
        reverse
        truncate 1
        
        transform :title, :name do |title|
          title.gsub(/Animal: /, '')
        end
      end
    end
  end
    
  describe "transformations" do
    it "should have renamed properties" do
      Smoke.test.output.first.should have_key(:title)
    end
    
    it "should sort by a given property" do
      Smoke.test.output.first[:title].should == "Platypus"
    end
    
    it "should reverse the results" do
      Smoke.test.output.should == [{:title => "Platypus", :name => "Peter"}]
    end
    
    it "should truncate results given a length" do
      Smoke.test.output.size.should == 1
    end
    
    it "should output" do
      Smoke.test.output.should be_an_instance_of(Array)
    end

    it "should output json" do
      Smoke.test.output(:json).should =~ /^\[\{/
    end

    it "should output yml" do
      Smoke.test.output(:yaml).should =~ /^--- \n- :/
    end
    
    it "should output xml" do
      Smoke.test.output(:xml).should include "<?xml version=\"1.0\"?>"
    end
    
    describe "filtering" do
      before :all do
        TestSource.source(:keep) do
          emit do
            keep(:head, /roo/)
          end
        end
        
        TestSource.source(:discard) do
          emit do
            discard(:head, /roo/)
          end
        end
      end
      
      it "should keep items" do
        Smoke[:keep].should(respond_to(:keep))
      end
      
      it "should only contain items that match" do
        Smoke[:keep].output.should == [{:head => "Animal: Kangaroo", :name => "Kelly"}]
      end
      
      it "should discard items" do
        Smoke[:discard].should(respond_to(:discard))
      end
      
      it "should not contain items that match" do
        Smoke[:discard].output.should == [{:head => "Animal: Platypus", :name => "Peter"}]
      end
    end
  end
  
  describe "dispatching" do  
    it "should dispatch when output is called" do
      TestSource.source(:no_dispatch)
      Smoke[:no_dispatch].should_not_receive(:dispatch)

      TestSource.source(:dispatch)
      Smoke[:dispatch].should_receive(:dispatch)
      Smoke[:dispatch].output
    end
  end
  
  describe "preperation" do
    before :all do
      @source = TestSource.source(:preperation)
    end
    
    it "should respond to prepare" do
      @source.should respond_to(:prepare)
    end
    
    it "should require a block" do
      lambda { @source.prepare }.should raise_error
      lambda { @source.prepare {} }.should_not raise_error
    end
  end
  
  describe "call order" do
    before :all do
      @url = "http://domain.tld/benschwarz/feed"
      FakeWeb.register_uri(:get, @url, :response => File.join(SPEC_DIR, 'supports', 'flickr-photo.json'))
      
      Smoke.data :feed_preperation_call_order do
        prepare do 
          url "http://domain.tld/#{username}/feed", :type => :json
        end
        
        path :photos, :photo
      end
    end
    
    describe "before setting variables" do
      it "should fail" do
        lambda { Smoke.feed_preperation_call_order.output }.should raise_error(NameError)
      end
    end
    
    describe "setting abstract properties" do
      it "should not respond to a property that hasn't been set" do
        lambda { Smoke.feed_preperation_call_order.abstract }.should raise_error(NoMethodError)
      end
      
      it "should allow setting a property" do
        lambda { Smoke.feed_preperation_call_order.abstract(:value) }.should_not raise_error(NoMethodError)
        Smoke.feed_preperation_call_order.abstract.should == :value
      end
      
      it "should set properties using method arguments" do
        lambda { Smoke.feed_preperation_call_order(:method_arg => :value) }.should_not raise_error(NoMethodError)
        Smoke.feed_preperation_call_order.method_arg.should == :value
      end
      
      it "should chain the source when setting a property" do
        Smoke.feed_preperation_call_order.abstract(:value).should be_an_instance_of(Smoke::Data)
      end
    end
    
    describe "after setting variables" do
      it "should output successfully" do
        lambda { Smoke.feed_preperation_call_order.username("benschwarz").output }.should_not raise_error
      end
      
      it "should have used the correct url" do
        Smoke.feed_preperation_call_order.request.uri.should == @url
      end
    end
  end

  describe "transformations" do
    it "should respond to emit" do
      Smoke.test.should respond_to(:emit)
    end
    
    it "emit should require a block" do
      lambda { Smoke.test.emit }.should raise_error
      lambda { Smoke.test.emit {} }.should_not raise_error
    end
    
    it "should respond to transform" do
      Smoke.test.should respond_to(:transform)
    end
    
    it "tranform should require a block" do
      lambda { Smoke.test.transform }.should raise_error
      lambda { Smoke.test.transform {} }.should_not raise_error
    end
    
    it "should have at least one transformation" do
      Smoke.test.transformation.size.should_not be_nil
    end
  end
  
  describe "key insertion" do
    before do
      TestSource.source(:insertion) do
        emit do
          insert(:source, "twitter")
        end
      end
    end
    
    it "should respond to insert" do
      Smoke.insertion.should respond_to(:insert)
    end
    
    it "should insert values into each key" do
      Smoke.insertion.output.first.should have_key :source
      Smoke.insertion.output.first[:source].should == "twitter"
    end
  end
  
  describe "sorting" do
    before :all do
      TestSource.source(:sorting) do
        emit do
          sort :header
        end
      end
      
      TestSource.source(:reversed) do
        emit do
          sort :header
          reverse
        end
      end
    end
    
    it "should softly error when attempting to sort on a key that doesn't exist" do
      Smoke[:sorting].output.should_not raise_error("NoMethodError")
    end
    
    it "should be reversed" do
      Smoke[:reversed].output.should == Smoke[:sorting].output.reverse
    end
  end
  
  describe "requirements" do
    before :all do      
      Smoke.data :requirements do
        prepare :require => [:username, :feed] do 
          url "http://domain.tld/#{feed}/#{username}/feed.json", :type => :json
        end
      end
      
      Smoke.data :single_requirement do
        prepare :require => :username do 
          url "http://domain.tld/#{feed}/#{username}/feed.json", :type => :json
        end
      end
    end
    
    it "should respond to requirements" do
      Smoke.requirements.should respond_to(:requirements)
    end
    
    it "should list its requirements" do
      Smoke.requirements.requirements.should include(:username)
      Smoke.requirements.requirements.should include(:feed)
      Smoke.requirements.requirements.length.should == 2
      Smoke.requirements.requirements.should be_an_instance_of(Array)
    end
    
    it "should have a single requirement, within an array" do
      Smoke.single_requirement.requirements.should be_an_instance_of(Array)
    end
    
  end
end