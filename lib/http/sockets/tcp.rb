require 'socket'
require 'http/sockets/base'

module Sockets
  SOCKET_HASH_KEY="HTTP::SOCKET_HASH"
  class TCP < Socket
    include Base

    Thread.current[SOCKET_HASH_KEY] ||= {}

    # should check if is keep_alive
    def self.open(host, port, timeout=10)
      key = "#{host}::#{port}::#{timeout}"

      socket = Thread.current[SOCKET_HASH_KEY][key]
      if socket && !socket.closed?
        socket
      else
        socket = create_socket(host, port, timeout)
        Thread.current[SOCKET_HASH_KEY][key] = socket if port != 443
        socket
      end
    end

    def self.create_socket(host, port, timeout=10)
      socket = new(:INET, :STREAM)

      # timeout for connection
      timeout_val = [timeout, 0].pack("l_2")

      socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, timeout_val)
      socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDTIMEO, timeout_val)

      socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true)

      addr = sockaddr_in(port, host)

      socket.connect(addr)

      socket
    end

  end

end