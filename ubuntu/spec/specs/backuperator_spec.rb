require_relative "../spec_helper.rb"
require_relative "../../components.rb"
#Specs for Helper methods for backup scripts

def setup_tests
  %x{mkdir ~/mockingdir}
  %x{touch ~/mockingdir/newfile1.txt ~/mockingdir/newfile2.txt ~/mockingdir/newfile3.txt}
  %x{mkdir ~/mockingdir/testdir1 ~/mockingdir/testdir2 ~/mockingdir/testdir3 ~/mockingdir/backup}
end

describe Backuperator do
  context "\n When Running a Backup" do
    let(:mock_directory){"~/mockingdir"}

    setup_tests unless File.exists?("~/mockingdir")
    GetEnvVariables.kick_off #Populates Configuratron with env info

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

    it "\n -Generates a file list array for each saved directory in the Configatron" do
      @sut.build_file_lists
      configatron.file_backup_list[mock_directory].should include "/home/#{configatron.user}/mockingdir/newfile1.txt"
      configatron.file_backup_list[mock_directory].should include "/home/#{configatron.user}/mockingdir/newfile2.txt"
    end

    before (:each) do
      @sut.build_file_lists
    end

    it "\n -Cuts the Config File Backup into a Config File Transfer List" do
      @sut.make_file_lists_expandable
      configatron.file_backup_list['~/mockingdir'].should include "newfile1.txt"
      configatron.file_backup_list['~/mockingdir'].should include "newfile2.txt"
    end

   it "\n -Expands Configatron File Transfer List to a Directory" do
     @sut.make_file_lists_expandable
     @sut.expand_to("~/backup")
     `ls ~/backup/mockingdir`.should include 'newfile1.txt'
   end
  end
end
