require 'eventmachine'
require File.expand_path('../lib/server.rb',__FILE__)
# Start SocketServer
EventMachine.run {
  EventMachine.start_server "127.0.0.1", 8080, SocketServer
}
