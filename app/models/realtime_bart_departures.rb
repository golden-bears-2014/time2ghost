class RealtimeBartDepartures
  require 'open-uri'
  attr_accessor :endpoint_and_departure_times

  def initialize(origin, destination)
    @origin = origin
    @destination = destination
    @url_builder = BartURLBuilder.new(origin, destination)
  end

  def get_departures
    get_route_name
    get_name_of_endpoint_station_on_route
    @endpoint_and_departure_times = get_upcoming_realtime_departures
  end

  def get_route_name
    route_xml = get_route_xml_from_bart_api
    @route_number = BartXMLParser.get_route_number_from_xml(route_xml)
  end

  def get_route_xml_from_bart_api
    open(@url_builder.build_routes_api_call) {|xml| xml.read }
  end

  def get_name_of_endpoint_station_on_route
    endpoint_xml = get_endpoint_xml_from_bart_api
    @endpoint = BartXMLParser.get_name_of_endpoint_station(endpoint_xml)
  end

  def get_endpoint_xml_from_bart_api
    open(@url_builder.build_endpoint_api_call(@route_number)) {|xml| xml.read }
  end

  def get_upcoming_realtime_departures
    realtime_departure_xml = get_realtime_departure_xml
    departure_times_array = BartXMLParser.filter_realtime_departures_by_correct_route(realtime_departure_xml, @endpoint)
    departure_times_hash = {}
    departure_times_hash[:endpoint] = @endpoint
    departure_times_hash[:departure_times] = departure_times_array
  end

  def get_realtime_departure_xml
    open(@url_builder.build_realtime_departures_api_call) {|xml| xml.read }
  end
end