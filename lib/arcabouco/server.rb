require 'sinatra'
require 'sinatra/base'
require 'sprockets'
require 'compass'
require 'sprockets-sass'
require 'pathname'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

module Arcabouco

  class WebServer < Sinatra::Base
    attr_accessor :base_dir

    set :views, Proc.new { Arcabouco.root + '/app' }

    def initialize()
      self.base_dir = Arcabouco.root
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

    def initialize
      self.root = Arcabouco.root
    end

    def run
      $environment = Sprockets::Environment.new
      $environment.append_path 'app/media'
      $environment.append_path 'app/js'
      $environment.append_path 'app/css'
      $environment.append_path File.join(Arcabouco.gem_root,'assets','css')
      $environment.append_path File.join(Arcabouco.gem_root,'assets','js')

      app = Arcabouco::WebServer.new

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
