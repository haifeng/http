require 'socket'
require 'http/sockets/base'
require 'pry'

module Sockets

  class TCP < Socket
    include Base

    # should check if is keep_alive
    def self.open(host, port, timeout=10)
      key = "#{host}::#{port}::#{timeout}"

      socket = Thread.current[key]
      if socket && !socket.closed?
        socket
      else
        socket = create_socket(host, port, timeout)
        Thread.current[key] = socket if port != 443
        socket
      end
    end

    def self.create_socket(host, port, timeout=10)
      socket = new(:INET, :STREAM)

      # timeout for connection
      timeout_val = [timeout, 0].pack("l_2")
      socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, timeout_val)
      socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDTIMEO, timeout_val)

      addr = sockaddr_in(port, host)

      socket.connect(addr)

      socket
    end

  end

end