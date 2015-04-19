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
      # Pathname.new(File.expand_path('../templates', File.dirname(__FILE__))).relative_path_from(Pathname.new(Arcabouco.root)).to_s
    end

    get '/manifest.appcache' do
      index_digest = Digest::MD5.new 
      index_digest.update content_for_index
      erb :"#{relative_to}/manifest", :locals => { :assets => $environment, :index_digest => index_digest.hexdigest }
    end

    get '/manifest.json' do
      content_type :json
      obj = {}
      obj['assets'] = {}
      Arcabouco.asset_list.each do |asset|
        next if asset.to_s.index("*")
        obj['assets'][asset] = $environment[asset.to_s].digest_path
      end
      obj.to_json
    end

    def content_for_index
      application_preload_html = ""
      application_preloader_filename = File.join Arcabouco.root, 'app', 'templates', 'application_preloader.html'
      if File.file?(application_preloader_filename)
        application_preload_html = File.read application_preloader_filename
      end
      erb :"#{relative_to}/index.html", locals: { :assets => $environment, :application_name => Arcabouco.application_name, :application_preload_html => application_preload_html}, layout: false, cache: false
    end

    get '/save_app.html' do
      erb :"#{relative_to}/save_app.html"
    end

    get '/*' do
      expires 0, :public, :'no-cache', :must_revalidate # Expire in 1 minute, require Auth
      content_for_index
    end
  end

  class Server
    attr_accessor :root
    attr_accessor :rack
    attr_accessor :env
    attr_accessor :web

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
      self.web = Arcabouco::WebServer.new
      web = self.web

      # app_css.write_to( Arcabouco.root + "/public/app-#{app_css.digest}.min.css" )
      $environment = self.get_env()
      self.rack = Rack::Builder.new do
        map '/app.assets' do
          run $environment
        end
        run web
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
      manifest.compile Arcabouco.asset_list

      compile_view "/", "index.html"
      compile_view "/save_app.html", "save_app.html"
      compile_view "/manifest.appcache", "manifest.appcache"
    end

    def run
      thin = Rack::Handler.get('thin')
      thin.run self.rack
    end
  end

end
