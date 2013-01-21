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
    configatron.file_backup_list[new_directory] = [] unless configatron.file_backup_list.include?(new_directory)
  end

  def build_file_lists #Populates Each Added Dir with the Files it Contains
    configatron.file_backup_list.each_key do |key|
      Dir.foreach(key){|file| configatron.file_backup_list[key] << file if File.file?("#{key}/#{file}")}
    end
  end

  def add_all_directories(from_this_directory) #check directories with spaces
    directory_search = `find #{from_this_directory} -type d`
    directory_list = directory_search.split("\n").to_a
    directory_list.each{|directory| add_directory(directory)}
  end

  def expand_to(backup_directory)  
    setup_logging
    @backup_directory = File.expand_path(backup_directory)
    configatron.file_backup_list.each_key do |directory|
      process_paths directory
      configatron.file_backup_list[directory].each{|file| execute_copy file}
    end
  end

  private

  def setup_logging
    logfile = File.expand_path '~/file_copy/backup.log'
    FileUtils.rm_r File.expand_path '~/file_copy' if File.exist? logfile
    FileUtils.mkdir File.expand_path '~/file_copy'
    @logger = Logger.new(logfile)
  end

  def execute_copy file
    begin
      FileUtils.cp "#{@directory}/#{file}","#{@backup_directory}#{@base_dir}/#{file}", :preserve => true
    rescue Errno::ENOENT
      @logger.error "#{$!} << File Not Copied"
    rescue Errno::EACCES
      @logger.error "#{$!} << File Not Copied"
    end
  end

  def process_paths directory
    @directory = directory
    @base_dir = directory.dup
    @base_dir.slice! configatron.user_path
    new_dir = "#{@backup_directory}/#{@base_dir}"
    `mkdir -p #{new_dir}` unless File.exists?(new_dir)
  end

end

