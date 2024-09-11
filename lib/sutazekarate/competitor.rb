module Sutazekarate
  class Competitor
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    attribute :id
    attribute :name
    attribute :club

    def self.build(data)
      name_element = Nokogiri::HTML5.fragment(data['meno'])
      name_link_element = name_element.search('a')
      id = Addressable::URI.parse(name_link_element.attr('href')).query_values['k']
      name = name_link_element.text.strip

      club_link_element = Nokogiri::HTML5.fragment(data['klub']).search('a')

      club_id = Addressable::URI.parse(club_link_element.attr('href')).query_values['klub']
      club_name = club_link_element.text.strip
      club = Club.new(id: club_id, name: club_name)

      new(
        id:,
        name:,
        club:,
      )
    end
  end
end