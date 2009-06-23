require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe Smoke::Origin do
  before :all do
    @origin = TestSource.source(:test) do
      emit do
        rename(:head => :title)
        sort(:title)
        
        transform :title, :name do |title|
          title.gsub(/Animal: /, '')
        end
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
      Smoke[:test].truncate(1).output.should == {:title => "Kangaroo", :name => "Kelly"}
    end
  end
  
  describe "transformations" do
    it "should rename properties" do
      Smoke[:test].rename(:title => :header).output.first.should have_key(:header)
    end
    
    it "should sort by a given property" do
      Smoke[:test].sort(:header).output.first[:header].should == "Kangaroo"
    end
    
    it "should reverse the results" do
      Smoke[:test].sort(:header).reverse.output.should == [{:header => "Platypus", :name => "Peter"}, {:header => "Kangaroo", :name => "Kelly"}]
    end
    
    it "should truncate results given a length" do
      Smoke[:test].truncate(1).output.should be_an_instance_of(Hash)
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
        Smoke[:keep].should(respond_to(:keep))
      end
      
      it "should only contain items that match" do
        Smoke[:keep].keep(:head, /^K/).output.should == {:head => "Kangaroo", :name => "Kelly"}
      end
      
      it "should discard items" do
        Smoke[:discard].should(respond_to(:discard))
      end
      
      it "should not contain items that match" do
        Smoke[:discard].discard(:head, /^K/).output.should == {:head => "Platypus", :name => "Peter"}
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
      @origin.output(:yaml).should =~ /^--- \n- :/
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
    TestSource.source(:chain) do
      emit do
        transform :head do |head|
          head.gsub(/Animal: /, '')
        end
      end
    end
    Smoke[:chain].rename(:head => :header).sort(:header).output.should == [{:header => "Kangaroo", :name => "Kelly"}, {:header => "Platypus", :name => "Peter"}]
  end
  
  it "should softly error when attempting to sort on a key that doesn't exist" do
    Smoke[:chain].sort(:header).should_not raise_error("NoMethodError")
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
        lambda { Smoke[:feed_preperation_call_order].output }.should raise_error(NameError)
      end
    end
    
    describe "setting abstract properties" do
      it "should not respond to a property that hasn't been set" do
        lambda { Smoke[:feed_preperation_call_order].abstract }.should raise_error(NoMethodError)
      end
      
      it "should allow setting a property" do
        lambda { Smoke[:feed_preperation_call_order].abstract(:value) }.should_not raise_error(NoMethodError)
        Smoke[:feed_preperation_call_order].abstract.should == :value
      end
      
      it "should chain the source when setting a property" do
        Smoke[:feed_preperation_call_order].abstract(:value).should be_an_instance_of(Smoke::Source::Data)
      end
    end
    
    describe "after setting variables" do
      it "should output successfully" do
        lambda { Smoke[:feed_preperation_call_order].username("benschwarz").output }.should_not raise_error
      end
      
      it "should have used the correct url" do
        Smoke[:feed_preperation_call_order].request.uri.should == @url
      end
    end
  end

  describe "transformations" do
    it "should respond to emit" do
      Smoke[:test].should respond_to(:emit)
    end
    
    it "emit should require a block" do
      lambda { Smoke[:test].emit }.should raise_error
      lambda { Smoke[:test].emit {} }.should_not raise_error
    end
    
    it "should respond to transform" do
      Smoke[:test].should respond_to(:transform)
    end
    
    it "tranform should require a block" do
      lambda { Smoke[:test].transform }.should raise_error
      lambda { Smoke[:test].transform {} }.should_not raise_error
    end
    
    it "should have at least one transformation" do
      Smoke[:test].transformation.size.should_not be_nil
    end
  end
  
  describe "key insertion" do
    it "should respond to insert" do
      Smoke[:test].should respond_to(:insert)
    end
    
    it "should insert values into each key" do
      Smoke[:test].insert(:source, "twitter").output.first.should have_key :source
      Smoke[:test].insert(:source, "twitter").output.first[:source].should == "twitter"
    end
    
    it "should work in a block" do
      TestSource.source(:inserts) do
        emit do
          insert :x, "exx"
        end
      end
      
      Smoke[:inserts].output.first.should have_key(:x)
    end
  end
end