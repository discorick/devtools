require_relative '../components.rb'

GetEnvVariables.kick_off
backup = Backuperator.new_backup

$backup_directory_list = []
eval File.read('resources/backup_list.rb')
abort("Warning! Cannot load 'resources/backup_list.rb' ... Aborting Backup") unless $backup_directory_list.length > 0
puts "About to backup the following folders: #{$backup_directory_list} ..."
$backup_directory_list.each{|saved_dir| backup.add_all_directories(saved_dir)}
backup.build_file_lists
backup.make_file_lists_expandable

puts "Backup to .... ?"
destination = gets.chomp
backup.expand_to destination
puts "Backup Finished"

