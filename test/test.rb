require 'eventmachine'
require 'rspec'
require File.expand_path('../support/helper_methods.rb',__FILE__)

describe "on sending test request" do
 include HelperMethods 
 it "should responsend with right answer" do    
    server_test({'id'=> 0, 'text' => "req1"}) do |response|
      response['text'].should == "answ1"
      response['id'].should == 0
    end
 end
end
