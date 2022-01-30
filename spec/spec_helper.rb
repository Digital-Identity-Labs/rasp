require "bundler"
require "serverspec"
require "docker-api"
require 'serverspec_extended_types'


image = Docker::Image.build_from_dir('.')

set :os, family: :debian
set :backend, :docker
set :docker_image, image.id

puts "Setup complete"