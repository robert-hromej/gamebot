require 'rubygems'
require 'json'
require 'net/http'

require './building'
require './city'
require './world'

require 'yaml'

$resuests = 1

loop do
  yml = YAML::load(File.open('config.yml'))

  $types = yml[:types]
  $filters = yml[:filters]

  yml[:worlds].each do |world_options|
    p "switch on the world '#{world_options[0]}'"
    world = World.new(world_options[1])
    world.upgrade_all_city
  end

  p "sleep 1 minute"
  sleep 1 * 60
end