require 'slop'

module Arcabouco

  class Command
    def self.run(args = ARGV)
      new.run(args)
    end

    def initialize
    end

    def run(args = ARGV)
      opts = Slop.parse do
        banner 'Usage: arcabouco [options]'

        on 's', 'server', 'Run as server'
        on 'b', 'build', 'Build'
      end
      Arcabouco::Application.new
      if opts.server?
        run_server
      elsif opts.build?
        run_build
      else
        puts opts
      end
    end

    private

      def help
        program = File.basename($0)
        [
          "#{program}:",
          "documentation",
          "goes here"
        ].join("\n")
      end

      def run_server
        Arcabouco::Server.new.run
      end

      def run_build
        server = Arcabouco::Server.new
        server.build()
      end

  end

end

