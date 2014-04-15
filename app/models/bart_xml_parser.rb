class BartXMLParser
  def self.get_route_numbers_from_xml(route_xml)
    routes = []
    Nokogiri::XML(route_xml).xpath('//leg').each {|leg| routes << leg.attributes["line"].value[-1]}
    routes.uniq!
  end

  def self.get_name_of_endpoint_station(endpoint_xml)
    Nokogiri::XML(endpoint_xml).at_xpath('//destination').content
  end

  def self.filter_realtime_departures_by_correct_route(realtime_xml, endpoints)
    possible_departures = {}
    path_to_endpoints = Nokogiri::XML(realtime_xml).xpath('//etd')
    endpoints.each do |current_endpoint|
      times = self.parse_times_for_one_endpoint(path_to_endpoints, current_endpoint)
      times.each{|x| possible_departures[x.text.to_i] = current_endpoint}
    end
      possible_departures.sort_by{|k, v| k.to_i}
  end

  def self.parse_times_for_one_endpoint(xml, endpoint)
    times_for_endpoint = xml.xpath("//abbreviation[contains(text(), '#{endpoint}')]").first.parent()
    times_for_endpoint.search('minutes')
  end

  def self.parse_bart_stations_list(stations_xml)
    Nokogiri::XML(stations_xml).xpath('//station')
  end
end

