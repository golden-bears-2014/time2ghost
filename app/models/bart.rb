=begin comment

This needs some refactoring.  There's a lot of repetition going on.  The fact that lines 8-13 are so full of this self.noise implies to me that this thing should be instantiated and that most of these methods should live under a `private` declaration.
=end

class Bart
  require 'open-uri'

  # These names suck.
  def self.get_departures(origin, destination) # origin what?  json?  class?  string?  name? BART code ?
    route_xml = self.get_route_xml(origin, destination)
    # this name sucks too: get_route_xml: are you getting the XML
    # representation of a route?  Or are you getting the XML representation of
    # a given trip?  I don't know what's going on here.  It's making me crabby.
    route = parse_route_xml(route_xml)
    endpoint_xml = self.get_endpoint_xml(route)
    endpoint = self.parse_endpoint_xml(endpoint_xml)
    realtime_xml = self.get_realtime_departure_xml(origin, endpoint)
    self.parse_realtime_departure_xml(realtime_xml, endpoint)
  end

  def self.get_route_xml(origin, destination)
    # this is some really heavy lifting that should probably go into its own
    # class.  Consider making a BartUrlBuilder class?
    open("http://api.bart.gov/api/sched.aspx?cmd=depart&orig=#{origin}&dest=#{destination}&key=MW9S-E7SL-26DU-VV8V") {|xml| xml.read }
  end

  def self.parse_route_xml(route_xml)
    Nokogiri::XML(route_xml).at_xpath('//leg').attributes["line"].value
  end

  def self.get_endpoint_xml(route_number)
    open("http://api.bart.gov/api/route.aspx?cmd=routeinfo&route=#{route_number[-1]}&key=MW9S-E7SL-26DU-VV8V") {|xml| xml.read }
  end

  def self.parse_endpoint_xml(endpoint_xml)
    Nokogiri::XML(endpoint_xml).at_xpath('//destination').content
  end

  def self.get_realtime_departure_xml(origin, endpoint)
    open("http://api.bart.gov/api/etd.aspx?cmd=etd&orig=#{origin}&key=MW9S-E7SL-26DU-VV8V") {|xml| xml.read }
  end

  def self.parse_realtime_departure_xml(realtime_xml, endpoint)
    path = Nokogiri::XML(realtime_xml).xpath('//etd')
    correct_destination = path.xpath("//abbreviation[contains(text(), '#{endpoint}')]").first.parent()

    # NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO
    #
    # Do not use the wrong enumerable.  When you do this shovel onto a blank
    # array you kill a kitten.  `each_with_object` or `inject` is the right one to
    # use.
    #
    # .inject([]){ |memo, item| memo << item.text}
    arrival_times = []
    correct_destination.search('minutes').each {|x| arrival_times << x.text}
    arrival_times << endpoint
  end
end
