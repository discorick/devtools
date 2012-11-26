require_relative '../components.rb'
#Script to Backup the contents of the Home/User Folder
#Prompts for addition locations for backup

class Backuperator
  def initialize
    configatron.file_backup_list = {}
  end

  def self.new_backup
    Backuperator.new
  end

  def add_directory(new_directory)
    configatron.file_backup_list[new_directory] = []
  end

  def make_file_lists
    configatron.file_backup_list.each_key do |key|
      configatron.file_backup_list[key] = %x{find #{key} -type f -maxdepth 1}
    end
  end
end




def make_file_list(filepath)
  Dir.chdir(filepath)
  list_files = %x{find -type f -maxdepth 1}
end
