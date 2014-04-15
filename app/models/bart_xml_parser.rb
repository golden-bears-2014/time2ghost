class BartXMLParser
  def self.get_route_numbers_from_xml(route_xml)
    # get all possible routes from origin to destination
    routes = []
    Nokogiri::XML(route_xml).xpath('//leg').each {|leg| routes << leg.attributes["line"].value[-1]}
    routes.uniq!
  end

  def self.get_name_of_endpoint_station(endpoint_xml)
    Nokogiri::XML(endpoint_xml).at_xpath('//destination').content
  end

  def self.filter_realtime_departures_by_correct_route(realtime_xml, endpoints)
    path = Nokogiri::XML(realtime_xml).xpath('//etd')
    possible_departures = {}
    endpoints.each do |current_endpoint|
      times_for_this_endpoint = path.xpath("//abbreviation[contains(text(), '#{current_endpoint}')]").first.parent()
      possible_departures[current_endpoint] = []
      times_for_this_endpoint.search('minutes').each{|x| possible_departures[current_endpoint] << x.text}
    end
    # returns hash with endpoint as key and realtime departures as minutes
    # i.e {"endpoint" => ["1", "2", "3"]}
      possible_departures
  end

  def self.parse_bart_stations_list(stations_xml)
    Nokogiri::XML(stations_xml).xpath('//station')
  end

end

