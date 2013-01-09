require_relative '../components.rb'

GetEnvVariables.kick_off
backup = Backuperator.new_backup

eval File.read('resources/backup_list.rb')
abort("Warning! Cannot load 'resources/backup_list.rb' ... Aborting Backup") unless $backup_directory_list.length > 0
puts "About to backup the following folders: \n"
$backup_directory_list.each{|dir|puts dir}
$backup_directory_list.each{|saved_dir| backup.add_all_directories(saved_dir)}

backup.build_file_lists
backup.make_file_lists_expandable

Strip.matching_elements_from_hash(configatron.file_backup_list,:each_value,[".x"])

puts "Backup to .... ?"
destination = gets.chomp
backup.expand_to destination
puts "Backup Finished"

