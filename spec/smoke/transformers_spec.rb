require "#{File.dirname(__FILE__)}/../spec_helper"

describe Smoke::Transformer do  
  describe "parsers" do
    it "should respond to parse" do
      Smoke::Transformers::Json.should respond_to(:parse)
    end
    
    it "should respond to parse" do
      Smoke::Transformers::XML.should respond_to(:parse)
    end

    it "should respond to parse" do
      Smoke::Transformers::Yaml.should respond_to(:parse)
    end
  end
  
  describe "generators" do
    it "should respond to generate" do
      Smoke::Transformers::Json.should respond_to(:generate)
    end
    
    it "should respond to generate" do
      Smoke::Transformers::XML.should respond_to(:generate)
    end

    it "should respond to generate" do
      Smoke::Transformers::Yaml.should respond_to(:generate)
    end
    
    it "should respond to generate" do
      Smoke::Transformers::Ruby.should respond_to(:generate)
    end
  end
end