#Update the components list with new files

components = File.open('components.rb', 'w')
components.puts "require 'configatron'"
components.puts ""
puts "Adding...."
Dir.glob("lib/**/*.rb").each do |file|
  require_file = "require_relative '#{file}'"
  puts "#{file}"
  components.puts require_file 
end

Dir.glob("scripts/**/*.rb").each do |file|
  require_file = "require_relative '#{file}'"
  puts "#{file}"
  components.puts require_file 
end
puts "To require list."
