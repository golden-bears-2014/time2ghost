class Station < ActiveRecord::Base
  attr_accessible :name, :abbr, :latitude, :longitude,
  :address, :city, :state, :zipcode

  def gmap_destination_string
    "#{self.latitude},#{self.longitude}"
  end
end