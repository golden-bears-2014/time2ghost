class StationBuilder
  require 'open-uri'

  def initialize(bart_api_stations_url)
    @bart_api_stations_url = bart_api_stations_url
  end

  def create_all_stations
  stations = open(@bart_api_stations_url) {|xml| xml.read}
  parsed_stations = BartXMLParser.parse_bart_stations_list(stations)

parsed_stations.each do |station|
 station_params = {
    :abbr => station.search('abbr')[0].text,
    :name => station.search('name')[0].text,
    :latitude => station.search('gtfs_latitude')[0].text,
    :longitude => station.search('gtfs_longitude')[0].text,
    :address => station.search('address')[0].text,
    :city => station.search('city')[0].text,
    :state => station.search('state')[0].text,
    :zipcode => station.search('zipcode')[0].text }
    Station.create(station_params)
  end

end


end

