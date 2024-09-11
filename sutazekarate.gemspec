require_relative 'lib/sutazekarate/version'

Gem::Specification.new do |spec|
  spec.name = 'sutazekarate'
  spec.version = Sutazekarate::VERSION
  spec.authors = ['Ahmed Al Hafoudh']
  spec.email = ['alhafoudh@freevision.sk']

  spec.summary = 'Web scraper for www.sutazekarate.sk'
  spec.description = 'Web scraper for www.sutazekarate.sk what read all competition data and allows to explore them in structured way.'
  spec.homepage = 'https://www.freevision.sk'
  spec.required_ruby_version = '>= 3.2.1'

  spec.metadata['homepage_uri'] = spec.homepage

  spec.files = Dir['lib/**/*', 'README.md']
  spec.require_paths = ['lib']
  spec.license = 'MIT'

  spec.add_dependency "http", "~> 5.2"
  spec.add_dependency "nokogiri", "~> 1.16"
  spec.add_dependency "zeitwerk", "~> 2.6"
  spec.add_dependency "activesupport", "~> 7.2"
  spec.add_dependency "activemodel", "~> 7.2"
  spec.add_dependency "concurrent-ruby", "~> 1.3"

  spec.add_development_dependency "pry", "~> 0.14.2"

  spec.metadata['rubygems_mfa_required'] = 'true'
end
