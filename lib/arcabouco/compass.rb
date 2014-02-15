require 'compass'

Compass.configuration do |compass|
  compass.sprite_load_path = [ 'app/sprites' ]
  compass.images_dir = 'app/media'
  compass.http_generated_images_path = '/app.assets/media'
end
