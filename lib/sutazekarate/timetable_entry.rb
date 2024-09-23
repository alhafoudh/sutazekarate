module Sutazekarate
  class TimetableEntry
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    attribute :title
    attribute :category
    attribute :time_range

    def serializable_hash(options = nil)
      super.merge(time_begin:, time_end:).except('time_range')
    end

    def time_begin
      time_range.begin
    end

    def time_end
      time_range.end
    end

    def self.build(entry_element, categories: [])
      title = entry_element.children.first.text.strip
      time_range_raw = entry_element.children.last.text.strip
      time_range_match = time_range_raw.match(/(\d+:\d+) - (\d+:\d+)/)
      time_range = Time.zone.parse(time_range_match[1])..Time.zone.parse(time_range_match[2])

      category = categories.find do |category|
        category.name == title
      end

      TimetableEntry.new(
        category:,
        title:,
        time_range:,
      )
    end
  end
end
