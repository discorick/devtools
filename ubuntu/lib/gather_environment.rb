require_relative '../components.rb'
#Gathers User Settings and Environment

class GetEnvVariables
  def initialize
    configatron.user = ENV['USER']
    configatron.user_path = "/home/#{configatron.user}"
  end

  def self.kick_off
    GetEnvVariables.new
  end
end
