class Station < ActiveRecord::Base
  attr_accessible :name, :abbr, :latitude, :longitude,
  :address, :city, :state, :zipcode

  def gmap_destination_string
    "#{self.latitude},#{self.longitude}"
  end

  def distance_to(user_lat, user_long)
    lat_difference = (user_lat - self.latitude.to_f).abs
    long_difference = (user_long - self.longitude.to_f).abs
    lat_difference + long_difference
  end

end