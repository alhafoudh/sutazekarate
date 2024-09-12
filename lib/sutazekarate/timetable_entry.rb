module Sutazekarate
  class TimetableEntry
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

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
  end
end
