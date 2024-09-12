module Sutazekarate
  class TimetableEntry
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    attribute :category
    attribute :time_range
  end
end
