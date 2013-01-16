require_relative '../components.rb'

class TimeThis 
  def self.now &block
    start = Time.now
    instance_eval &block
    puts "Process took #{Time.now - start} to complete"
  end
end

GetEnvVariables.kick_off
backup = Backuperator.new_backup

eval File.read('resources/backup_list.rb')
abort("Warning! Cannot load 'resources/backup_list.rb' ... Aborting Backup") unless $backup_directory_list.length > 0

puts "Preparing File Lists: \n \n"
$backup_directory_list.each{|saved_dir| backup.add_all_directories(saved_dir)}

Strip.matching_elements_from_hash(configatron.file_backup_list,:each_key,$ignore_directories)

configatron.file_backup_list.each_key{|dir|puts dir}
backup.build_file_lists
backup.make_file_lists_expandable

Strip.matching_elements_from_hash(configatron.file_backup_list,:each_value,$ignore_files)


puts "Backup to .... ?"
destination = gets.chomp
backup.expand_to destination
puts "Backup Finished"

