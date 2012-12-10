require_relative "../spec_helper.rb"
require_relative "../../components.rb"
#Specs for Helper methods for backup scripts

def setup_tests
  %x{mkdir ~/mockingdir}
  %x{touch ~/mockingdir/newfile1.txt ~/mockingdir/newfile2.txt ~/mockingdir/newfile3.txt}
  %x{mkdir ~/mockingdir/testdir1 ~/mockingdir/testdir2 ~/mockingdir/testdir3}
end

describe Backuperator do
  context "\n When Running a Backup" do
    let(:mock_directory){"/home/discorick/mockingdir"}

    setup_tests 
    GetEnvVariables.kick_off #Populates Configuratron with env info

    before (:each) do
      @sut = Backuperator.new_backup
    end

    it "\n -Adds a Directory to the Configurator" do
      configatron.file_backup_list = {}
      @sut.add_directory(mock_directory)
      configatron.file_backup_list[mock_directory].length.should equal 0
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

    it "\n -Makes File List Expandable" do
      @sut.make_file_lists_expandable
      configatron.file_backup_list[mock_directory].should include "newfile1.txt"
      configatron.file_backup_list[mock_directory].should include "newfile2.txt"
    end

   it "\n -Expands Configatron File Transfer List to a Directory" do
     @sut.make_file_lists_expandable
     @sut.expand_to("#{configatron.user_path}/backuperator_test")
     `ls ~/backuperator_test/mockingdir`.should include 'newfile1.txt'
   end

   it "\n -Adds a File Tree to the File Backup List" do
     @sut.add_all_directories("#{configatron.user_path}/mockingdir")
    configatron.file_backup_list.should include '/home/discorick/mockingdir/testdir3'
   end

   after (:all) do
     `rm -r ~/mockingdir`
     `rm -r ~/backuperator_test`
   end
  
  end
end
