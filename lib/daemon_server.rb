module DaemonServer
  include EM::P::ObjectProtocol

  def post_init
    @@connections_pool ||= ConnectionPool.new(:size => 5)
  end

  def receive_object(obj)
    @@connections_pool.request obj do |response|
      send_object(response)
      close_connection_after_writing
    end
  end

end

