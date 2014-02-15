require 'sinatra'
require 'sinatra/base'
require 'sprockets'
require 'pathname';

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

module Arcabouco

  class WebServer < Sinatra::Base
    attr_accessor :base_dir

    set :views, Proc.new { Arcabouco.root + '/app' }

    def initialize(root)
      self.base_dir = File.expand_path(root)
      super
    end

    def relative_to
      "../" + Pathname.new(File.expand_path('../templates', File.dirname(__FILE__))).relative_path_from(Pathname.new(Arcabouco.root)).to_s
    end

    get '/manifest.appcache' do
      erb :"#{relative_to}/manifest", :locals => { :assets => $environment }
    end

    get '/*' do
      haml :"#{relative_to}/index", locals: { :assets => $environment }, layout: false
    end
  end

  class Server
    attr_accessor :root

    def initialize(options)
      self.root = options[:root] 
    end

    def run
      $environment = Sprockets::Environment.new
      $environment.append_path 'app/media'
      $environment.append_path 'app/js'
      $environment.append_path 'app/css'

      app = Arcabouco::WebServer.new(self.root)

      rack = Rack::Builder.new do
        map '/app.assets' do
          run $environment
        end
        run app
      end

      thin = Rack::Handler.get('thin')
      thin.run rack
    end
  end

end
