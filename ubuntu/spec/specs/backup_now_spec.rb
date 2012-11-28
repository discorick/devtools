require_relative "../spec_helper.rb"
require_relative "../../lib/backup_now.rb"
require_relative "../../components.rb"
#Specs for Backing up Home/User Folder

def setup_tests
  %x{mkdir ~/mockingdir}
  %x{touch ~/mockingdir/newfile1.txt ~/mockingdir/newfile2.txt ~/mockingdir/newfile3.txt}
  %x{mkdir ~/mockingdir/testdir1}
  %x{mkdir ~/mockingdir/testdir2}
  %x{mkdir ~/mockingdir/testdir3}
end

describe Backuperator do
  context "\n When Running a Backup" do
    let(:mock_directory){'~/mockingdir'}

    setup_tests if File.exists?("~/mockingdir")
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
      puts @sut.make_file_lists
      @sut.make_file_lists
      configatron.file_backup_list[mock_directory].should include "/home/#{configatron.user}/mockingdir/newfile1.txt"
    end

    before (:each) do
      @sut.make_file_lists
    end

    it "\n -Cuts the Config File Backup into a Config File Transfer List" do
      @sut.make_file_lists_transferable
      configatron.transfer_list['/mockingdir'].should_not include "/home/#{configatron.user}"
    end

   it "\n -Expands Configatron File Backup List to a Directory" do
     @sut.expand_to("#{configatron.user_path}/backup")
     `ls ~/mockingdir/backup/mockingdir`.should include 'newfile1.txt'
   end
  end
end
