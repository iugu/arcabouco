module Arcabouco

  class Command
    def self.run(args = ARGV)
      new.run(args)
    end

    def initialize
    end

    def run(args = ARGV)
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
        puts "Starting WebServer" 
        # Arcabouco::Server.new.run
      end
  end

end

