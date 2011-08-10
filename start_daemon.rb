require 'eventmachine'
require File.expand_path('../lib/connection_pool.rb',__FILE__)
require File.expand_path('../lib/daemon_server.rb',__FILE__)
require 'daemons'

options = {
  :app_name => 'ProxyServer',
  :backtrace => true,
  :log_output => true,
  :dir_mode => :normal,
  :dir => File.expand_path('../tmp',__FILE__)
}

file = File.expand_path('../tmp/daemon.sock',__FILE__)
File.unlink(file) if File.exists?(file)

Daemons.daemonize(options) if ARGV.index('-d')

def stop_and_exit
  p "Process killed at #{Time.now}"
  exit 0
end
 
Signal.trap('INT') { stop_and_exit }
Signal.trap('TERM'){ stop_and_exit }

EventMachine::run {
  EventMachine::start_unix_domain_server(file, DaemonServer)
}
