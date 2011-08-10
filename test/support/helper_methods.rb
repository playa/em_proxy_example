APP_ROOT = File.expand_path('../../../',__FILE__)
SOCK_FILE = File.expand_path('../tmp/test.sock',__FILE__)

require File.join(APP_ROOT,'lib/connection_pool.rb')
require File.join(APP_ROOT,'lib/daemon_server.rb')
require File.join(APP_ROOT,'lib/server.rb')
require File.expand_path('../testclient.rb',__FILE__)

module HelperMethods
  def start_serv
    File.unlink(SOCK_FILE) if File.exists?(SOCK_FILE)
    EM.run {
      EventMachine.start_server "127.0.0.1", 8080, SocketServer
      EventMachine.start_unix_domain_server(SOCK_FILE, DaemonServer)
      client = EM.connect_unix_domain(SOCK_FILE, TestClient)
      yield client
    }    
  end

  # if request takes to long it will show fail
  def timer start
    timeout = 6
    EM.add_timer(timeout){
      (Time.now-start).should be_within(0).of(timeout)
      EM.stop
    }
  end

  #main wrapper for test starts server daemon and client
  def server_test request
    time = Time.now
    start_serv do |client|
      client.send_request request do |response|
        yield response 
      end
      client.onclose= lambda{EM.stop}
      timer(time)
    end
  end

end
