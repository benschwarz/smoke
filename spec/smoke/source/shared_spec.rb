require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

shared_examples_for "all sources" do
  describe "transforms" do
  
    it "emit should require a block" do
      lambda { @source.emit }.should raise_error
      lambda { @source.emit {} }.should_not raise_error
    end
    
    it "should respond to transform" do
      @source.should respond_to(:transform)
    end
    
    it "transform should require a block" do
      lambda { @source.transform }.should raise_error
      lambda { @source.transform {} }.should_not raise_error
    end
    
    it "should have at least one transformation" do
      @source.transformation.size.should_not be_nil
    end
  end
  
  describe "key insertion" do
    it "should respond to insert" do
      @source.should respond_to(:insert)
    end
    
    it "should insert values into each key" do
      @source.insert(:source, "twitter").output.first.should have_key :source
      @source.insert(:source, "twitter").output.first[:source].should == "twitter"
    end
  end
  
  describe "general object transformations" do
    it "should respond to emit" do
      @source.should respond_to(:emit)
    end
    
    it "should rename properties" do
      @source.rename(:title => :header).output.first.should have_key(:header)
    end
    
    it "should sort by a given property" do
      @source.sort(:header).output.first[:header].should == "Kangaroo"
    end
    
    it "should reverse the results" do
      @source.sort(:header).reverse.output.should == [{:header => "Platypus", :name => "Peter"}, {:header => "Kangaroo", :name => "Kelly"}]
    end
    
    it "should truncate results given a length" do
      @source.truncate(1).output.should be_an_instance_of(Hash)
    end
    
    describe "filtering" do
      before do
        TestSource.source(:keep) do
          emit do
            transform :head do |head|
              head.gsub(/Animal: /, '')
            end
          end
        end
        
        TestSource.source(:discard) do
          emit do
            transform :head do |head|
              head.gsub(/Animal: /, '')
            end
          end
        end
      end
      
      it "should keep items" do
        @source.should(respond_to(:keep))
      end
      
      it "should only contain items that match" do
        @source.keep(:head, /^K/).output.should == {:head => "Kangaroo", :name => "Kelly"}
      end
      
      it "should discard items" do
        @source.should(respond_to(:discard))
      end
      
      it "should not contain items that match" do
        @source.discard(:head, /^K/).output.should == {:head => "Platypus", :name => "Peter"}
      end
    end
  end
  
  describe "output" do
    it "should output" do
      @source.output.should be_an_instance_of(Array)
    end

    it "should output a single hash when there is only one result"

    it "should output two items" do
      @source.output.size.should == 2
    end

    it "should output json" do
      @source.output(:json).should =~ /^\[\{/
    end

    it "should output yml" do
      @source.output(:yaml).should =~ /^--- \n- :/
    end
    
    it "should dispatch when output is called" do
      TestSource.source(:dispatch)
      @source.should_receive(:dispatch)
      @source.output
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
      FakeWeb.register_uri(@url, :response => File.join(SPEC_DIR, 'supports', 'flickr-photo.json'))
      
      Smoke.data :feed_preperation_call_order do
        prepare do 
          url "http://domain.tld/#{username}/feed"
        end
        
        path :photos, :photo
      end
    end
    
    describe "before setting variables" do
      it "should fail" do
        lambda { @source.output }.should raise_error(NameError)
      end
    end
    
    describe "setting abstract properties" do
      it "should not respond to a property that hasn't been set" do
        lambda { @source.abstract }.should raise_error(NoMethodError)
      end
      
      it "should allow setting a property" do
        lambda { @source.abstract(:value) }.should_not raise_error(NoMethodError)
        @source.abstract.should == :value
      end
      
      it "should chain the source when setting a property" do
        @source.abstract(:value).should be_an_instance_of(Smoke::Source::Data)
      end
    end
    
    describe "after setting variables" do
      it "should output successfully" do
        lambda { @source.username("benschwarz").output }.should_not raise_error
      end
      
      it "should have used the correct url" do
        @source.request.uri.should == @url
      end
    end
  end
end