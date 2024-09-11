module Sutazekarate
  class Stage
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    attribute :index
    attribute :pairs
  end
end
