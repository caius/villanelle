# frozen_string_literal: true

require "async/io"
require "async/io/stream"

def run
  Async do |task|
    endpoint = Async::IO::Endpoint.tcp("irc.freenode.net", 6667)
    endpoint.connect do |socket|
      # Writer task
      writer_task = task.async do
        socket.write(p("NICK caiusbot\r\n"))
        socket.write(p("USER caiusbot 0 * :caiusbot\r\n"))

        # FIXME: feed lines to write into here
      end

      # Reader task
      stream = Async::IO::Stream.new(socket)
      while (message = stream.read_until("\r\n"))
        puts message
      end
    ensure
      writer_task&.stop
    end
  end
end

run
