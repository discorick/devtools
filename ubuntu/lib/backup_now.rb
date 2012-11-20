#Script to Backup the contents of the Home/User Folder
#Prompts for addition locations for backup

class GetEnvVariables
  attr_reader :user, :user_path
  def initialize
    @user = ENV['USER']
    @user_path = "/home/#{@user}"
  end

  def self.kick_off
    GetEnvVariables.new
  end
end
