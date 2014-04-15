require 'open-uri'
require 'nokogiri'

stations = open('http://api.bart.gov/api/stn.aspx?cmd=stns&key=MW9S-E7SL-26DU-VV8V') {|xml| xml.read}

parsed_stations = Nokogiri::XML(stations).xpath('//station')

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

u = User.create(username: "Lucas", password: "testtest", phone_number: "8184212905", email: "lucas@lucas.com")
BartTrip.create(user_id: u.id, departure_station: "24TH", destination_station: "PITT", current_location: "3159 23rd st, 94110")
BartTrip.create(user_id: u.id, departure_station: "24TH", destination_station: "PITT", current_location: "3159 23rd st, 94110")

