require 'socket'
require 'openssl'

require 'http/sockets/base'

module Sockets
  class SSL < OpenSSL::SSL::SSLSocket
    include Base
  end
end