class BartXMLParser
  def self.get_route_number_from_xml(route_xml)
    Nokogiri::XML(route_xml).at_xpath('//leg').attributes["line"].value[-1]
  end

  def self.get_name_of_endpoint_station(endpoint_xml)
    Nokogiri::XML(endpoint_xml).at_xpath('//destination').content
  end

  def self.filter_realtime_departures_by_correct_route(realtime_xml, endpoint)
    path = Nokogiri::XML(realtime_xml).xpath('//etd')
    correct_destination = path.xpath("//abbreviation[contains(text(), '#{endpoint}')]").first.parent()
    departure_times = correct_destination.search('minutes').inject([]){ |all_times, departure_time| all_times << departure_time.text}
    departure_times << endpoint
  end

  def self.parse_bart_stations_list(stations_xml)
    Nokogiri::XML(stations_xml).xpath('//station')
  end

end

