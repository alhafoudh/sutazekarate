module Sutazekarate
  class Category
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    include Logging
    include Concurrent::Async

    attribute :id
    attribute :position
    attribute :name
    attribute :discipline
    attribute :location
    attribute :location_color
    attribute :time_range

    def competitors
      @competitors ||= begin
        logger.debug("Fetching competitors for category #{id}")
        response = HTTP.get("https://www.sutazekarate.sk/ajax/av_kategoriazoz.php?kategoria=#{id}&order=asc&limit=1000&offset=0")
        rows = JSON.parse(response.body.to_s)
        rows.map do |row|
          Competitor.build(row)
        end
      end
    end

    def ladder
      @ladder ||= begin
        logger.debug("Fetching ladder for category #{id}")
        response = HTTP.get("https://www.sutazekarate.sk/sutaze_kategoriarozl.php?k=#{id}")
        html = Nokogiri::HTML5(response.body.to_s)

        export_element = html.search('a').find do |elem|
          elem.attr('href').start_with?('pdf_rozlosovanieexport.php')
        end
        export_url = "https://www.sutazekarate.sk/#{export_element.attr('href')}"

        stages = []

        stage_index = 0
        loop do
          stage_element = html.search(".stlpecn.posun#{stage_index}").first
          unless stage_element
            break
          end

          pairs = stage_element.search('.obalao').map.with_index do |pair_element, pair_index|
            competitors = pair_element.search('.okienkopavukR').map do |competitor_element|
              id_element = competitor_element.search('#sutaziaci').first
              unless id_element
                next nil
              end

              id = competitor_element.search('#sutaziaci').first.attr('value')
              name = competitor_element.search('.meno').text.strip
              club = competitor_element.search('.klub').text.strip

              Competitor.new(
                id: id,
                name: name,
                club: Club.new(name: club),
              )
            end

            Pair.new(
              index: pair_index,
              competitor1: competitors[0],
              competitor2: competitors[1],
            )
          end

          stages << Stage.new(
            index: stage_index,
            pairs:,
          )

          stage_index += 1
        end

        Ladder.new(
          export_url:,
          stages:,
        )
      end
    end

    def preload
      [
        async.competitors,
        async.ladder,
      ]
    end

    def preload!
      preload.map(&:value)
    end

    def self.build(data)
      detail_element = Nokogiri::HTML5.fragment(data['detail'])
      id = Addressable::URI.parse(detail_element.search('a').first.attr('href')).query_values['k']
      category_element = Nokogiri::HTML5.fragment(data['kategoria'])
      category_span_elements = category_element.search('span')
      name = category_span_elements[0].text.strip
      detail_element = category_span_elements[1]
      location = nil
      location_color = nil
      time_range = nil
      if detail_element
        location_color = detail_element.attr('class').match(/c-(\w+)/)[1]
        detail_match = detail_element.text.strip.match(/(.+) \/(.+) - (.+)\//)

        location = detail_match[1]
        time_range = Time.zone.parse(detail_match[2])..Time.zone.parse(detail_match[3])
      end
      discipline = Nokogiri::HTML5.fragment(data['disciplina']).text.strip

      new(
        id:,
        position: data['pc'],
        name:,
        discipline:,
        location:,
        location_color:,
        time_range:,
      )
    end
  end
end