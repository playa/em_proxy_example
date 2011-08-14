require 'eventmachine'
require File.expand_path('../lib/client.rb',__FILE__)
#emulate many clients
#tc => connection number arg
tc = ARGV[0].to_i
TOTAL_CONNECTIONS = tc > 0 ? tc : 25

file = File.expand_path('../tmp/daemon.sock',__FILE__)
p "Starting #{TOTAL_CONNECTIONS} client(s)"
EventMachine::run { 
  TOTAL_CONNECTIONS.times{ EM.connect_unix_domain(file, EMClient) }
} 
