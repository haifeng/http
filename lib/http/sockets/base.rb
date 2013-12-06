require 'socket'

module Sockets

  module Base
    def read_data(length, timeout=10)
      begin
        read_nonblock(length)
      rescue IO::WaitReadable
        socket = IO.select([self], [], [], timeout)
        raise "TimeoutNow" if socket.nil?
        retry
      end
    end
  end

end