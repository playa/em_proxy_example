module EMClient
  include EM::P::ObjectProtocol 

  @@connection_number = 0
  @@dissconnected = 0

  #send request as the connection has been established
  def post_init
    @@connection_number += 1
    send_object({'id'=> rand(10), 'text' => "req#{@@connection_number}"})
  end

  
  def receive_object(obj)  
    #display response from server
    p obj.inspect
  end

  def unbind
    @@dissconnected += 1
    #stop reactor after all requests have been processed
    EM.stop if @@dissconnected == TOTAL_CONNECTIONS
  end
end





