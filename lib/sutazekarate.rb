require 'zeitwerk'
require 'active_support/all'
require 'active_model'
require 'http'
require 'nokogiri'

Time.zone_default = Time.find_zone!(ENV.fetch('TZ', 'Europe/Bratislava'))

loader = Zeitwerk::Loader.for_gem
loader.setup

module Sutazekarate
end

loader.eager_load