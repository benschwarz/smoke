require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Smoke do
  describe "registration" do
    before do
      Smoke.register(Smoke::SecretSauce) # defined in supports/mayo.rb
    end
    
    it "should allow sources to register themselves" do
      Smoke.included_modules.should include(SecretSauce)
    end
    
    it "should have an instance method of 'mayo'" do
      Smoke.instance_methods.should include("mayo")
    end
  end
end