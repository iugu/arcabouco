module Arcabouco

  def self.root
    @@root
  end
  def self.root=(root)
    @@root = root
  end

  class Application
    class InvalidArgumentsError < StandardError; end

    attr_accessor :options

    def self.run(args = ARGV)
      new.run(args)
    end

    def initialize
      self.options = {}
    end

    def run(args = ARGV)
      @options = parse(args)
      case
      when options[:start]
        run_server
      when options[:help]
        puts help
      when options[:version]
        puts version
      else
        puts help
      end
    end


    private

      def parse(args)
        args = normalize_args args
        options[:help] = extract_boolean args, '-h', '--help'
        options[:start] = extract_boolean args, 'start'
        options[:package] = extract_boolean args, 'package'
        options[:root] = extract_root args
        options
      end

      def help
        program = File.basename($0)
        [
          "#{program}:",
          "documentation",
          "goes here"
        ].join("\n")
      end

      def normalize_args(args)
        args = args.join(' ')
        args.gsub!(%r{http://}, '')
        args.split(/[ :]/).compact
      end

      def extract_arg_and_value(args, opts)
        opts.each do |opt|
          index = args.index(opt)
          next unless index
          key = args.delete_at(index)
          value = args[index]
          if value !~ /^-/
            args.delete_at(index)
            return value.nil? ? true : value
          end
        end
        nil
      end

      def extract_root(args)
        args.reverse.each do |dir|
          if File.directory?(dir)
            args.delete(dir)
            return File.expand_path(dir)
          end
        end
        '.'
      end

      def extract_boolean(args, *opts)
        !(extract_arg_and_value args, opts).nil?
      end

      def run_server
        root = options[:root]
        Dir.chdir(root)
        root = Dir.getwd
        Arcabouco.root = root
        puts "Starting WebServer" 
        Arcabouco::Server.new(root: root).run
      end

  end

end
