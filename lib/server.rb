module SocketServer
  include EM::P::ObjectProtocol
  def post_init
    #p "Daemon connected to the socket server!"
  end

  def receive_object(obj)  
    #emulation of job on server
    EM.add_timer(1+rand(5)) do
      #validation of obj goes here))
      obj['text'].sub!(/req/,'answ') 
      send_object(obj)
    end    
    p "Server received object: #{obj.inspect}"
  end

  def unbind
    #p "Daemon disconnected from the socket server!"
  end
end


