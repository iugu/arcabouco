# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "arcabouco/version"

Gem::Specification.new do |s|
  s.name        = "arcabouco"
  s.version     = Arcabouco::VERSION
  s.authors     = ["Patrick Negri"]
  s.email       = ["support@iugu.com"]
  s.homepage    = ""
  s.summary     = %q{Arcabouco WebApp Framework}
  s.description = %q{Arcabouco WebApp Framework}

  s.rubyforge_project = "arcabouco"

  s.files = Dir["README.md", "LICENSE", "Rakefile", "app/**/*", "lib/**/*", "vendor/**/*"]

  s.executables = ["arcabouco"]

  s.require_paths = ["lib"]

  s.add_dependency 'rack'
  s.add_dependency 'sinatra'
  s.add_dependency 'thin'
  s.add_dependency 'sprockets'
  s.add_dependency 'sprockets-sass'
  s.add_dependency 'sprockets-helpers'
  s.add_dependency 'coffee-script'
  s.add_dependency 'haml'
  s.add_dependency 'sass'

  s.add_dependency 'eco'
  s.add_dependency 'guard-sprockets'
  s.add_dependency 'yui-compressor'

  s.add_dependency 'compass'

  s.add_dependency 'rake'
end
