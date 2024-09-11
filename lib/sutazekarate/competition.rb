module Sutazekarate
  class Competition
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    include Logging
    include Concurrent::Async

    attribute :id
    attribute :starts_at
    attribute :name
    attribute :club
    attribute :location
    attribute :note
    attribute :registration_starts_at
    attribute :registration_ends_at

    def categories
      @categories ||= begin
        logger.debug("Fetching categories for competition #{id}")
        response = HTTP.get("https://www.sutazekarate.sk/ajax/av_sutazkat.php?lang=sk&sutaz=#{id}&order=asc&limit=1000&offset=0")
        rows = JSON.parse(response.body.to_s)
        rows.map do |row|
          Category.build(row)
        end
      end
    end

    def self.all(year: Date.today.year)
      logger.debug("Fetching competitions for year #{year}")
      response = HTTP.get("https://www.sutazekarate.sk/ajax/av_sutaze.php?lang=sk&r=#{year}&sort=datum&order=desc&limit=1000&offset=0")
      rows = JSON.parse(response.body.to_s)['rows']
      rows.map do |row|
        starts_at = Date.parse(row['datum'])
        content = Nokogiri::HTML5.fragment(row['obsah'])

        name = content.search('h4').first.text.strip
        club_element = content.search('h5').first
        club = club_element.text.strip
        id = Addressable::URI.parse(content.search('a').first.attr('href')).query_values['sutaz']
        location = club_element.next_sibling.text.strip
        note_element = content.search('br').first.next_sibling
        note = if note_element.text?
          note_element.text
        else
          nil
        end

        registration_info_element = content.search('span').find do |elem|
          elem.text.include?('Registrácia: ')
        end
        registration_info = registration_info_element.text
        registration_info_match = registration_info.match(/Registrácia: (.+) - (.+)/)
        registration_starts_at = Date.parse(registration_info_match[1])
        registration_ends_at = Date.parse(registration_info_match[2])

        Competition.new(
          id:,
          starts_at:,
          name:,
          club:,
          location:,
          note:,
          registration_starts_at:,
          registration_ends_at:,
        )
      rescue => ex
        binding.pry
      end
    end
  end
end