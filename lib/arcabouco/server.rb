require 'sinatra'
require 'sinatra/base'
require 'rack/test'
require 'sprockets'
require 'compass'
require 'sprockets-sass'
require 'handlebars_assets'
require 'pathname'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
HandlebarsAssets::Config.template_namespace = 'JST'

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
    attr_accessor :rack
    attr_accessor :env

    def initialize
      self.root = Arcabouco.root
      setup_env
      setup_rack
    end

    def setup_env
      self.env = Sprockets::Environment.new
      self.env.append_path 'app/media'
      self.env.append_path 'app/js'
      self.env.append_path 'app/css'
      self.env.append_path HandlebarsAssets.path
      self.env.append_path File.join(Arcabouco.gem_root,'assets','css')
      self.env.append_path File.join(Arcabouco.gem_root,'assets','js')
    end

    def get_env
      self.env 
    end

    def get_rack
      self.rack
    end

    def setup_rack
      app = Arcabouco::WebServer.new

      # app_css.write_to( Arcabouco.root + "/public/app-#{app_css.digest}.min.css" )
      $environment = self.get_env()
      self.rack = Rack::Builder.new do
        map '/app.assets' do
          run $environment
        end
        run app
      end
      self.rack
    end

    def compile_view(path,output)
      browser = Rack::Test::Session.new(Rack::MockSession.new(rack))
      response = browser.get path, {}
      File.open(Arcabouco.root + "/public/" + output, 'w+') do |f|
        f.puts response.body
      end
    end

    def prepare_env_for_build
      self.env.js_compressor = :uglify
      self.env.css_compressor = :sass
    end

    def build
      FileUtils.mkpath Arcabouco.root + "/public"
      FileUtils.mkpath Arcabouco.root + "/public/app.assets"

      prepare_env_for_build

      manifest = Sprockets::Manifest.new(env, Arcabouco.root + "/public/app.assets/manifest.json")
      manifest.compile(%w(app.css app.js vendor.js vendor.css *.png))

      compile_view "/", "index.html"
      compile_view "/manifest.appcache", "manifest.appcache"
    end

    def run
      thin = Rack::Handler.get('thin')
      thin.run self.rack
    end
  end

end
