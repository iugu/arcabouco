module Arcabouco
  class Application
    def initialize
      configure_root_directory
      puts "Configured root #{Arcabouco.root}"
    end

    private

      def configure_root_directory
        Dir.chdir "."
        Arcabouco.root = File.expand_path Dir.getwd
      end
  end
end
