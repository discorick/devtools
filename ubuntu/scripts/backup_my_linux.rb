require_relative '../components.rb'

#notes.. 
#- Would you like to backup up home?
#- Full or Recursive? (Warning! Recursive will backup ALL file and directories in current user

def enter_to_continue
  puts "Push enter to continue" 
  continue = gets
  exit if continue.chomp == 'exit'
end

class TimeThis 
  def self.now &block
    start = Time.now
    instance_eval &block
    puts "Process took #{Time.now - start} to complete"
  end
end

begin
  require_relative 'resources/backup_list.rb'
rescue LoadError
  puts"\n'resources/backup_list.rb' Not Found! Try recloning the repo."
  enter_to_continue
end

GetEnvVariables.kick_off
backup = Backuperator.new_backup
puts "File Backup Script"
enter_to_continue
system("clear")

puts "Backup Files in Home Folder? (y/n) \n"
confirm = gets.chomp
if confirm == 'y'
  puts "\n1 Recursive \n2 Non-Recursive \n"
  puts "Warning!!! Recursive will copy ALL file AND directory contents of #{configatron.user}"
  $recursive_option = gets.to_i
  backup.add_all_directories("#{configatron.user_path}") if $recursive_option == 1
  backup.add_directory("#{configatron.user_path}") if $recursive_option == 2
end
system("clear")

puts "Backup Other Folders? (y/n) \nBe Aware you are already doing a FULL backup of this account" if $recursive_option == 1
puts "Backup Other Folders? (y/n)" if $recursive_option != 1
confirm2 = gets.chomp
if confirm2 == "y"
  $backup_directory_list.each{|saved_dir| backup.add_all_directories(saved_dir)}
end
Strip.matching_elements_from_hash(configatron.file_backup_list,:each_key,$ignore_directories)
system("clear")

puts "No Folders Have Been Specified! Exiting..." if configatron.file_backup_list.length == 0 
exit if configatron.file_backup_list.length == 0 

puts "Folders to Backup: \n \n"
configatron.file_backup_list.each_key{|dir|puts dir}
enter_to_continue
system("clear")

puts "\n \nPreparing File Lists: \n \n"
backup.build_file_lists
Strip.matching_elements_from_hash(configatron.file_backup_list,:each_value,$ignore_files)

configatron.file_backup_list.each_key{|k| puts k}
puts "Backup to .... ?"
destination = gets.chomp
TimeThis.now do
  backup.expand_to destination
  puts "Backup Finished"
end

