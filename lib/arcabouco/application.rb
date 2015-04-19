module Arcabouco
  class Application
    def initialize
      configure_root_directory
      puts "Booting Arcabouco #{Arcabouco::VERSION}"
      config_filename = File.join Arcabouco.root, 'config.rb'
      if File.file?(config_filename)
        require config_filename
      end
    end

    private

      def configure_root_directory
        Arcabouco.gem_root = File.expand_path("../..",__FILE__)
        Arcabouco.root = File.expand_path Bundler.root
        Dir.chdir Arcabouco.root
      end
  end
end
