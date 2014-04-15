class RealtimeBartDepartures
  require 'open-uri'

  def initialize(origin, destination)
    @origin = origin
    @destination = destination
  end

  def get_departures
    get_route_name
    get_name_of_endpoint_station_on_route
    get_upcoming_realtime_departures
  end

  private

  def get_route_name
    route_xml = get_route_xml_from_bart_api
    get_route_name_from_parsed_xml(route_xml)
  end

  def get_route_xml_from_bart_api
    open("http://api.bart.gov/api/sched.aspx?cmd=depart&orig=#{@origin}&dest=#{@destination}&key=MW9S-E7SL-26DU-VV8V") {|xml| xml.read }
  end

  def get_route_number_from_parsed_xml
    @route_number = Nokogiri::XML(route_xml).at_xpath('//leg').attributes["line"].value[-1]
  end

  def get_name_of_endpoint_station_on_route
    endpoint_xml = get_endpoint_xml_from_bart_api
    @endpoint = get_name_of_endpoint_station(endpoint_xml)
  end

  def get_endpoint_xml_from_bart_api
    open("http://api.bart.gov/api/route.aspx?cmd=routeinfo&route=#{@route}&key=MW9S-E7SL-26DU-VV8V") {|xml| xml.read }
  end

  def get_name_of_endpoint_station(endpoint_xml)
    Nokogiri::XML(endpoint_xml).at_xpath('//destination').content
  end

  def get_upcoming_realtime_departures
    realtime_departure_xml = get_realtime_departure_xml
    filter_realtime_departures_by_correct_route(realtime_departure_xml)
  end

  def get_realtime_departure_xml
    open("http://api.bart.gov/api/etd.aspx?cmd=etd&orig=#{@origin}&key=MW9S-E7SL-26DU-VV8V") {|xml| xml.read }
  end

  def filter_realtime_departures_by_correct_route(realtime_xml)
    path = Nokogiri::XML(realtime_xml).xpath('//etd')
    correct_destination = path.xpath("//abbreviation[contains(text(), '#{@endpoint}')]").first.parent()
    arrival_times = []
    correct_destination.search('minutes').each {|x| arrival_times << x.text}
    arrival_times << endpoint
  end
end