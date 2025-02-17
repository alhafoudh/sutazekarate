module Sutazekarate
  class Competition
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    include Logging

    class << self
      include Logging
    end

    include Concurrent::Async

    attribute :id
    attribute :image_url
    attribute :starts_at
    attribute :name
    attribute :club
    attribute :location
    attribute :note
    attribute :registration_starts_at
    attribute :registration_ends_at
    attribute :attachments

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

    def preload
      categories.map do |category|
        category.async.preload
      end.flatten
    end

    def preload!
      preload.map(&:value)
    end

    def timetables
      @timetables ||= begin
        logger.debug("Fetching timetable for competition #{id}")
        response = HTTP.get("https://sutazekarate.sk/pdf_timetable3.php?sutaz=#{id}")

        html = Nokogiri::HTML5.fragment(response.body.to_s)

        html.search('.divttm').map do |location_element|
          Timetable.build(location_element, categories:)
        end
      end
    end

    def self.find(id)
      logger.debug("Fetching competition with id #{id}")

      response = HTTP.get("https://www.sutazekarate.sk/sutaze_sutazinf.php?sutaz=#{id}")
      html = Nokogiri::HTML5.fragment(response.body.to_s)

      image_path = html.search('img.img-responsive.no-margin').attr('src').value
      image_url = "https://www.sutazekarate.sk/#{image_path}"
      name = html.search('h3.section-title-inner').text.strip.rpartition(' - ').first
      club = html.search('.table1 tr:nth-child(1) td:nth-child(2)').text.strip

      starts_at = Date.parse(html.search('.table1 tr:nth-child(2)  td:nth-child(2)').text.strip)

      registration_info = html.search('.table1 tr:nth-child(4) td:nth-child(2)').text.strip
      registration_starts_at, registration_ends_at = registration_info.split(' - ').map do |date|
        Date.parse(date)
      end

      attachments = html.search('.table1 tr').reduce([]) do |acc, row|
        acc += row.search('td:nth-child(2) a[target="_blank"]').map do |a|
          "https://www.sutazekarate.sk/#{a.attr('href')}"
        end
          .grep_v(/\.php/)

        acc
      end

      Competition.new(
        id:,
        image_url:,
        starts_at:,
        name:,
        club:,
        registration_starts_at:,
        registration_ends_at:,
        attachments:,
      )
    end

    def self.all(year: Date.today.year)
      logger.debug("Fetching competitions for year #{year}")
      response = HTTP.get("https://www.sutazekarate.sk/ajax/av_sutaze.php?lang=sk&r=#{year}&sort=datum&order=desc&limit=1000&offset=0")
      rows = JSON.parse(response.body.to_s)['rows']
      rows.map do |row|
        starts_at = Date.parse(row['datum'])
        content = Nokogiri::HTML5.fragment(row['obsah'])
        image = Nokogiri::HTML5.fragment(row['obrazok'])

        image_path = image.search('img').attr('src').value
        image_url = "https://www.sutazekarate.sk/#{image_path}"
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
          image_url:,
          starts_at:,
          name:,
          club:,
          location:,
          note:,
          registration_starts_at:,
          registration_ends_at:,
        )
      end
    end
  end
end