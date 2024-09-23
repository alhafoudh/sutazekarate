module Sutazekarate
  class Timetable
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    attribute :location
    attribute :entries

    def self.build(location_element, categories: [])
      location = location_element.search('.hlavicka').text.strip

      entries = location_element.search('ul li').map do |entry_element|
        TimetableEntry.build(entry_element, categories:)
      end

      Timetable.new(
        location:,
        entries:,
      )
    end
  end
end
