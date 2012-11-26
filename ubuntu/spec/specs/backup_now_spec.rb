require_relative "../spec_helper.rb"
require_relative "../../lib/backup_now.rb"
require_relative "../../components.rb"
#Specs for Backing up Home/User Folder

def setup_tests
  %x{mkdir ~/mockingdir}
  %x{touch ~/mockingdir/newfile1.txt ~/mockingdir/newfile2.txt ~/mockingdir/newfile3.txt}
end

describe Backuperator do
  context "\n When Running a Backup" do
    let(:mock_directory){'~/mockingdir'}

    setup_tests if File.exists?("~/mockingdir")
    GetEnvVariables.kick_off

    before (:each) do
      @sut = Backuperator.new_backup
    end

    it "\n -Adds a Directory to the Configurator" do
      configatron.file_backup_list = {}
      @sut.add_directory(mock_directory)
      configatron.file_backup_list[mock_directory].length.should equal 0
    end

    it "\n -Raises a Notice when adding a duplicate directory" do
      expect {@sut.add_directory(mock_directory)}.to raise_error
    end

    before (:each) do
      @sut.add_directory(mock_directory)   
    end

    it "\n -Generates a file list for each saved directory in the Configurator" do
      @sut.make_file_lists
      configatron.file_backup_list[mock_directory].should include "/home/#{configatron.user}/mockingdir/newfile1.txt"
    end


  end
end
