class RealtimeBartDepartures
  require 'open-uri'
  attr_accessor :endpoint_and_departure_times

  def initialize(origin, destination)
    @origin = origin
    @destination = destination
    @url_builder = BartURLBuilder.new(origin, destination)
  end

  def get_departures
    get_route_names
    get_name_of_endpoint_stations_on_routes
    @endpoints_and_departure_times = get_upcoming_realtime_departures
  end

  def get_route_names
    route_xml = get_route_xml_from_bart_api
    @route_numbers = BartXMLParser.get_route_numbers_from_xml(route_xml)
  end

  def get_route_xml_from_bart_api
    open(@url_builder.build_routes_api_call) {|xml| xml.read }
  end

  def get_name_of_endpoint_stations_on_routes
    endpoint_xml_array = get_endpoint_xml_array_from_bart_api
    @endpoints = []
    endpoint_xml_array.each do |current_endpoint_xml|
     @endpoints <<  BartXMLParser.get_name_of_endpoint_station(current_endpoint_xml)
   end
   @endpoints
  end

  def get_endpoint_xml_array_from_bart_api
    endpoint_xml_array = []
    @route_numbers.each do |route_number|
      endpoint_xml_array << open(@url_builder.build_endpoint_api_call(route_number)) {|xml| xml.read }
    end
    endpoint_xml_array
  end

  def get_upcoming_realtime_departures
    realtime_departure_xml = get_realtime_departure_xml
    departure_times_hash = BartXMLParser.filter_realtime_departures_by_correct_route(realtime_departure_xml, @endpoints)
    departure_times_hash
  end

  def get_realtime_departure_xml
    open(@url_builder.build_realtime_departures_api_call) {|xml| xml.read }
  end
end