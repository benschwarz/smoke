require "#{File.dirname(__FILE__)}/../../../spec_helper"

describe Parser do
  [Json Ruby XML Yaml].each do |p|
    it "should respond to parse" do
      p.should respond_to(:parse)
    end
  end
end