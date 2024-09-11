module Sutazekarate
  class Ladder
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    attribute :export_url
    attribute :stages
  end
end
