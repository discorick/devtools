require_relative '../components.rb'

GetEnvVariables.kick_off
backup = Backuperator.new_backup

$backup_directory_list = ['/home/discorick/repositories']
puts $backup_directory_list
puts "Enter to continue"
continue = gets

$backup_directory_list.each{|saved_dir| backup.add_all_directories(saved_dir)}
puts configatron.file_backup_list
backup.build_file_lists
backup.make_file_lists_expandable

puts "Backup to ....?"
destination = gets.chomp
backup.expand_to destination

puts "Copy Finished"

