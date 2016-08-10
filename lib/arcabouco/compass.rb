require 'compass'


Compass.configuration do |compass|
  compass.sprite_load_path = [ 'app/sprites' ]
  compass.images_dir = 'app/media'
  compass.css_dir = 'app/css'
  compass.sass_dir = 'app/css'
  compass.javascripts_dir = 'app/js'
  compass.relative_assets = false
  # compass.assetCacheBuster = false
  compass.generated_images_dir = 'public/app.assets'
  compass.http_generated_images_path = '/app.assets'
end

