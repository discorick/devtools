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

  def add_directory(new_directory) #use ~/ NOT /home/user
    notice = "Notice: #{new_directory} has already been added!"
    raise notice if configatron.file_backup_list.has_key? new_directory
    configatron.file_backup_list[new_directory] = ""
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
        filename.slice! "/home/#{configatron.user}/#{directory[2..-1]}/"
      end
    end
  end

  def expand_to(backup_directory)
    configatron.file_backup_list.each_key do |directory|
      new_dir = "#{backup_directory}/#{directory[2..-1]}"
      `mkdir -p #{new_dir}` unless File.exists?(new_dir)
      configatron.file_backup_list[directory].each do |file|
        `cp #{directory}/#{file} #{backup_directory}/#{directory[2..-1]}`
      end
    end
  end

end
