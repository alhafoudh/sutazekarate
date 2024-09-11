module Sutazekarate
  class Pair
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    attribute :index
    attribute :competitor1
    attribute :competitor2
  end
end
