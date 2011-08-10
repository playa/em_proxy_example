module EMConnection
  include EM::P::ObjectProtocol

  def receive_object(obj)
    #calling callback on object receiving
    @callback.call(obj)
  end

  def send_request obj, &block 
    #sending data to server and setting callback
    send_object obj
    @callback = block
  end

end

#simple connection pool using EM queue, default size 10
class ConnectionPool
 
  def initialize(conf)
    @pool_size = conf[:size] || 10
    @connections = []
    @query_queue = EM::Queue.new
    start_queue conf
  end
  
  def queue_worker_loop
    proc{ |connection|
      @query_queue.pop do |request|
        connection.send_request(request[:obj]) do |response|
          request[:callback].call response #if request[:callback]
          queue_worker_loop.call connection
        end
      end
    }
  end
  
  def start_queue(conf)
    @pool_size.times do
      connection = EM.connect('0.0.0.0', 8080, EMConnection)
      @connections << connection
      queue_worker_loop.call connection
    end
  end
  
  def request(obj, &block)
    @query_queue.push :obj => obj, :callback => block
  end
end
 
