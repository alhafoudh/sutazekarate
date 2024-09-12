module Sutazekarate
  class Timetable
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    attribute :location
    attribute :entries
  end
end
