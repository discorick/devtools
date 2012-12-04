require_relative '../components.rb'
#Todo ... Script to recursively add folders into an array 

backup = Backuperator.new_backup

puts "Type in where the $backup_directory_list is located"
location = gets.chomp
require location

$backup_directory_list.each{|saved_dir| backup.add_directory(saved_dir)}
backup.build_file_lists
backup.make_file_lists_expandable

puts "Backup to ....?"
destination = gets.chomp
backup.expand_to destination

puts "Copy Finished"

