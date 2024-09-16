require 'zeitwerk'
require 'active_support/all'
require 'active_model'
require 'http'
require 'nokogiri'

unless Time.zone
  Time.zone_default = Time.find_zone!(ENV.fetch('TZ', 'Europe/Bratislava'))
end

loader = Zeitwerk::Loader.for_gem
loader.setup

module Sutazekarate
end

loader.eager_load