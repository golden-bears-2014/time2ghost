# Seriously, do you have an allergy to `initialize` methods?
#
# Please explain your model of "we never instantiate anything."
#
# The fact that you keep fixating on these self methods makes me beleive you
# have never heard of the pattern known as METHOD OBJECT:
#
# http://refactoring.com/catalog/replaceMethodWithMethodObject.html
class GoogleMaps
  require 'uri'

  def self.http_get_directions(origin, destination)
    url = self.assemble_directions_request(origin, destination)

    HTTParty.get(url).parsed_response
  end

  def self.get_total_walking_time(gmaps_returned_json)
    # these names suck.
    # this is brittle
    # what does this dereferencing snarl mean?  is it "duration of the first
    # leg's route?  Why not make a method that returns this datum?  This is
    # super-brittle.
    #
    # I'm detecking the code smell known as PRIMITIVE OBSESSION here.  You're
    # keeping this hash noise around, it would be so much better if these
    # primitive data were wrapped in an object that has decent names (not sucky
    # names).
    gmaps_returned_json["routes"][0]["legs"][0]["duration"]["value"] / 60
  end

  def self.parse_directions(gmaps_returned_json)
    # Dudes.  Seriously.  http://www.ruby-doc.org/core-2.1.1/Enumerable.html
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
