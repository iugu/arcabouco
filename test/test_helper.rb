require 'minitest/autorun'
# DatabaseCleaner.strategy = :truncation
# DatabaseCleaner.strategy = :transaction

# load File.dirname(__FILE__) + '/../db/seeds.rb'

require "#{File.expand_path(File.dirname(__FILE__))}/support/setup_minitest"
Dir["#{File.expand_path(File.dirname(__FILE__))}/support/*.rb"].each do |file|
  require file
end

