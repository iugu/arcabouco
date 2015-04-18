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
        Arcabouco.root = File.expand_path Bundler.root
        Dir.chdir Arcabouco.root
      end
  end
end
