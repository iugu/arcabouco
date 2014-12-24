module Arcabouco
  class Application
    def initialize
      configure_root_directory
      puts "Configured root #{Arcabouco.root}"
      puts "Configured gem root #{Arcabouco.gem_root}"
    end

    private

      def configure_root_directory
        Arcabouco.gem_root = File.expand_path("../..",__FILE__)
        Dir.chdir "."
        Arcabouco.root = File.expand_path Dir.getwd
      end
  end
end
