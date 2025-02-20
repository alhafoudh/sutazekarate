module Sutazekarate
  class Pool
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    attribute :title
    attribute :stages
  end
end
