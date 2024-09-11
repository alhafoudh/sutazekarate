module Sutazekarate
  class Club
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    attribute :id
    attribute :name
  end
end