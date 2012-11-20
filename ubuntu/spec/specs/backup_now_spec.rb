require_relative "../spec_helper.rb"
require_relative "../../lib/backup_now.rb"
#Specs for Backing up Home/User Folder

describe "Run to backup files to another location" do
  context "When executing the default backup" do
    #Identify responsibilites, test without using specific information

    before (:each) do
      @new_backup = Backuperator.setup
    end

    it "\n -Outputs  a file list from a directory" do
      @new_backup.make_file_list("/home/discorick")
    end
  end
end
