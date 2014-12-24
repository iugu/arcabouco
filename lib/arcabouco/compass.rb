require 'compass'


Compass.configuration do |compass|
  compass.sprite_load_path = [ 'app/sprites' ]
  compass.images_dir = 'app/media'
  compass.css_dir = 'app/css'
  compass.sass_dir = 'app/css'
  compass.javascripts_dir = 'app/js'
  compass.relative_assets = true
  compass.http_generated_images_path = '/app.assets/media'
end

