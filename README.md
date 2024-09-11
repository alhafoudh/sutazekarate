# Sutazekarate

Web scraper for www.sutazekarate.sk

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sutazekarate'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sutazekarate

## Usage

List all competitions

        puts Sutazekarate::Competition.all

List all categories for competition

        puts competition.categories

## Development

After checking out the repo, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.