# I hate this class so much.  It's doing way too much, it makes me mad.  It's
# confusing.  I'm .... sad looking at it.
#
#  This 5 magic number irritates me.  Why is update_departure_time on this
#  class?  I don't even....know what you're trying to do.  You confuse me.
class Trip < ActiveRecord::Base
  attr_accessible :user_id, :departure_station, :destination_station, :walking_time, :directions,
  :train_departing_time, :bart_line, :recommended_leave_time, :current_location
  belongs_to :user

  def update_departure_time
    depart_station_obj = get_station(self.departure_station)

    self.walking_time = get_walking_time_to_station(current_location, depart_station_obj.gmap_destination_string)

    potential_depart_times = get_depart_times_and_line

    minutes_until_departure = get_minutes_until_train_departs(potential_depart_times)

    set_train_departing_time(minutes_until_departure)

    suggested_leave_time_in_minutes_from_now = minutes_until_departure - walking_time - 5

    set_recommended_leave_time(suggested_leave_time_in_minutes_from_now)

    self.save!
  end

  # What is this about?
  def self.get_trips_for_current_minute
    @trips = Trip.where("recommended_leave_time = ?", Time.now.change(:sec => 0))
  end

  # How does a trip know this?
  def find_closest_station(user_lat, user_long)
    stations = Station.all
    closest_bart_distance = stations.first.distance_to(user_lat, user_long)
    closest_station = stations.first
    stations.each do |station|
      station_distance = station.distance_to(user_lat, user_long)
      if station_distance < closest_bart_distance
        closest_bart_distance = station_distance
        closest_station = station
      end
    end
    closest_station
  end

  private
  def set_recommended_leave_time(suggested_leave_time_in_minutes_from_now)
    self.recommended_leave_time = remove_seconds_from_time(Time.now + suggested_leave_time_in_minutes_from_now.minutes)
  end

  def get_depart_times_and_line
    depart_times = Bart.get_departures(self.departure_station, self.destination_station)
    self.bart_line = get_station(depart_times.pop).name
    depart_times
  end

  def set_train_departing_time(minutes_until_departure)
    self.train_departing_time = remove_seconds_from_time(Time.now + minutes_until_departure.to_i.minutes)
  end

  def get_minutes_until_train_departs(potential_depart_times)
    potential_depart_times.find { |depart_time| depart_time.to_i - self.walking_time - 5 > 0 }.to_i
  end

  def remove_seconds_from_time(time)
    time.change(:sec => 0)
  end

  def get_station(abbr)
    Station.find_by_abbr(abbr.upcase)
  end

  def get_walking_time_to_station(origin, destination)
    gmaps_json = GoogleMaps.http_get_directions(origin, destination)
    GoogleMaps.get_total_walking_time(gmaps_json)
  end

end
