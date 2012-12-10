require_relative '../components.rb'
#Methods to assist Backup Scripts
#Run Backuperator.new_backup to refresh configatron.file_backup_list

class Backuperator
  def initialize
    configatron.file_backup_list = {}
  end

  def self.new_backup
    Backuperator.new
  end

  def add_directory(new_directory) #use absolute paths
    configatron.file_backup_list[new_directory] = "" unless configatron.file_backup_list.include?(new_directory)
  end

  def build_file_lists #Populates Each Added Dir with the Files it Contains
    configatron.file_backup_list.each_key do |key|
      configatron.file_backup_list[key] = %x{find #{key} -maxdepth 1 -type f}
      configatron.file_backup_list[key] = configatron.file_backup_list[key].split("\n").to_a
    end
  end

  def make_file_lists_expandable
    configatron.file_backup_list.each_key do |directory|
      configatron.file_backup_list[directory].each do |filename|
        filename.slice! "#{directory}/"
      end
    end
  end

  def add_all_directories(from_this_directory)
    directory_search = `find #{from_this_directory} -type d`
    directory_list = directory_search.split("\n").to_a
    directory_list.each{|directory| add_directory(directory)}
  end

  def expand_to(backup_directory) 
    configatron.file_backup_list.each_key do |directory|
      base_dir = directory.dup
      base_dir.slice! configatron.user_path
      new_dir = "#{backup_directory}/#{base_dir}"
      `mkdir -p #{new_dir}` unless File.exists?(new_dir)
      configatron.file_backup_list[directory].each do |file|
        `cp #{directory}/#{file} #{backup_directory}/#{base_dir}`
      end
    end
  end

end
