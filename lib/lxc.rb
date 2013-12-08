#!/opt/vagrant_ruby/bin/ruby

require 'rubygems'
require 'json'
require 'mixlib/shellout'

def print_message(state, msg, key="failed")
  message = {
    key   => state,
    "msg" => msg
  } 
  print message.to_json
  exit 1 if state == false
end

def conf_file_config(config_file)
  config_file.nil? ? nil : "-f #{config_file}"
end

lxc_path = "/var/lib/lxc"
template = "sshd" #default template
config_file = nil
name = nil 

args_file = ARGV[0] || print_message(false, "Following options supported: name=<container name>; optional arguments: config=<config_path>")
data = File.read(args_file) || print_message(false, "Unable to read file #{args_file}")

arguments = data.split(" ")

arguments.each do |argument|
  print_message(false, "Arguments should be name value pairs.Example: name=foo") if not argument.include?("=") 
  field,value = argument.split("=")
  case field
    when "name"
      name = value
    when "template"
      template = value
    when "config_file"
      config_file = value
    else
      print_message(false, "Invalid arguments provided . Valid arguments include template and config_file")
  end 
end
#All well.Time to create

print_message(false,"Name parameter not provided") if name.nil?

lxc_check = Mixlib::ShellOut.new("sudo lxc-ls | grep #{name}").run_command
print_message(false, "Lxc #{name} already exists") if lxc_check.status.exitstatus == 0

lxc = Mixlib::ShellOut.new("sudo lxc-create -n #{name} -t #{template} #{conf_file_config(config_file)}").run_command
if lxc.status.exitstatus == 0
  print_message(true,"Lxc #{name} successfully created","changed")
else
  print_message(false,"Failed to created container. Logs - #{lxc.stdout}")
end
