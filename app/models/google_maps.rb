class GoogleMaps
  require 'uri'
  attr_accessor :parsed_response

  def initialize
    @parsed_response
  end

  def http_get_directions(origin, destination)
    url = self.assemble_directions_request(origin, destination)
    @parsed_response = HTTParty.get(url).parsed_response
  end

  def get_total_walking_time
    @parsed_response["routes"][0]["legs"][0]["duration"]["value"] / 60
  end

  def self.get_total_walking_time(gmaps_returned_json)
    gmaps_returned_json["routes"][0]["legs"][0]["duration"]["value"] / 60
  end

  def parse_directions
    directions = []
    @parsed_response["routes"][0]["legs"][0]["steps"].each do |step|
      directions << step["html_instructions"]
    end

    directions
  end

  def self.parse_directions(gmaps_returned_json)
    directions = []
    gmaps_returned_json["routes"][0]["legs"][0]["steps"].each do |step|
      directions << step["html_instructions"]
    end
    directions
  end

  private
  def self.assemble_directions_request(origin, destination)
    params = {
      :origin => origin,
      :destination => destination,
      :sensor => false,
      :mode => "walking"
    }

    "https://maps.googleapis.com/maps/api/directions/json?" + URI.encode_www_form(params)
  end

end


# Demo link
# https://maps.googleapis.com/maps/api/directions/json?origin=717+california+street&destination=montgomery+st+station&sensor=false&mode=walking