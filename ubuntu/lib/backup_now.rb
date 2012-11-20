require 'scriptme.rb'
#Script to Backup the contents of the Home/User Folder
#Prompts for addition locations for backup

class Backuperator
  def make_file_list(filepath)
    Dir.chdir(filepath)
    list_files = %x{find -type f -maxdepth 1}
  end

  def self.setup
    Backuperator.new
  end
end
