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
    notice = "Notice: #{new_directory} has already been added!"
    raise notice if configatron.file_backup_list.has_key? new_directory
    configatron.file_backup_list[new_directory] = ""
  end

  def make_file_lists
    configatron.file_backup_list.each_key do |key|
      configatron.file_backup_list[key] = %x{find #{key} -maxdepth 1 -type f}
      configatron.file_backup_list[key] = configatron.file_backup_list[key].split("\n").to_a
    end
  end

  def make_file_lists_transferable

  end

  def expand_to(backup_directory)

  end
end
