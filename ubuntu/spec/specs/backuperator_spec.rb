require_relative "../spec_helper.rb"
require_relative "../../components.rb"
#Specs for Helper methods for backup scripts

def setup_tests
  %x{mkdir ~/mockingdir}
  FileUtils.touch '/home/discorick/mockingdir/new file4.txt'
  FileUtils.mkdir '/home/discorick/mockingdir/test dir4'
  FileUtils.mkdir '/home/discorick/mockingdir/.test dir4'
  FileUtils.mkdir '/home/discorick/mockingdir/.test dir4/pushed_back'
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
      configatron.file_backup_list[mock_directory].should include "newfile1.txt"
      configatron.file_backup_list[mock_directory].should include "new file4.txt"
      configatron.file_backup_list[mock_directory].should include "newfile2.txt"
    end

    before (:each) do
      @sut.build_file_lists
    end

   it "\n -Adds a File Tree to the File Backup List" do
     @sut.add_all_directories("#{configatron.user_path}/mockingdir")
    configatron.file_backup_list.should include "#{configatron.user_path}/mockingdir/testdir3"
    configatron.file_backup_list.should include "#{configatron.user_path}/mockingdir/test dir4"
    configatron.file_backup_list.should include "#{configatron.user_path}/mockingdir/.test dir4/pushed_back"
   end

   it "\n -Expands Files into Directory" do
     @sut.add_all_directories("#{configatron.user_path}/mockingdir")
     @sut.expand_to("~/backuperator_test")
     file = File.exist? "/home/discorick/backuperator_test/mockingdir/new file4.txt"
     file.should == true
   end

   after (:all) do
     `rm -r ~/mockingdir`
     `rm -r ~/backuperator_test` if File.exists?("#{configatron.user_path}/backuperator_test")
   end
  
  end
end
