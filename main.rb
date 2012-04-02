require 'rubygems'
require 'json'
require 'net/http'

require './lib/building'
require './lib/city'
require './lib/world'

require 'yaml'

$resuests = 1

loop do
  yml = YAML::load(File.open('config.yml'))

  $types = yml[:types]
  $filters = yml[:building_plans]

  yml[:worlds].each do |world_options|
    world = World.new(world_options[1])
    world.trade_minister
    world.building_minister
  end

  p "sleep 1 minute"
  sleep 1 * 60
end