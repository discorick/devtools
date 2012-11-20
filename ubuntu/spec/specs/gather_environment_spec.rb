require_relative "../spec_helper.rb"
require_relative "../../lib/backup_now.rb"
#Specs for Environment Gathering Methods

describe "Gathers Working Environment Variables" do
  context "When detecting current user info..." do

    before (:each) do
      $ENV = GetEnvVariables.kick_off
    end

    it "\n -Detects Home/User" do
      $ENV.user.should == ENV['USER']
    end

    it "\n -Builds a Path to the USER Folder" do
      $ENV.user_path.should == "/home/#{$ENV.user}"
    end
  end
end

 
