module TestClient
  include EM::P::ObjectProtocol 

  #on object received callback
  def receive_object(obj)  
    @onresponse.call(obj)
    p "Client received object: #{obj.inspect}"
  end

  def send_request obj, &block
    @onresponse = block 
    send_object obj     
  end
  
  # on disconnect callback
  def onclose=(proc)
    @onclosed = proc
  end
  
  def unbind
    @onclosed.call 
  end

end
