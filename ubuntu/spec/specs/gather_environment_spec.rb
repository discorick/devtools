require_relative "../spec_helper.rb"
require_relative "../../lib/gather_environment.rb"
require_relative "../../components.rb"
#Specs for Environment Gathering Methods

describe "Gathers Working Environment Variables" do
  context "When detecting current user info..." do

    GetEnvVariables.kick_off

    it "\n -Detects Home/User" do
      configatron.user.should == ENV['USER']
    end

    it "\n -Builds a Path to the USER Folder" do
      configatron.user_path.should == "/home/#{configatron.user}"
    end
  end
end

 
