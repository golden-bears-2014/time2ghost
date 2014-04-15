class BartTrip < ActiveRecord::Base
  attr_accessible :user_id, :departure_station, :destination_station, :walking_time, :directions,
  :train_departing_time, :bart_line, :recommended_leave_time, :current_location
  belongs_to :user

  def update_departure_time
    depart_station_obj = get_station(self.departure_station)

    gmaps = GoogleMaps.new
    gmaps.http_get_directions(current_location, depart_station_obj.gmap_destination_string)
    self.walking_time = gmaps.get_total_walking_time

    potential_depart_times = get_depart_times_and_line

    minutes_until_departure = get_minutes_until_train_departs(potential_depart_times)

    set_train_departing_time(minutes_until_departure)

    suggested_leave_time_in_minutes_from_now = minutes_until_departure - self.walking_time - 5

    set_recommended_leave_time(suggested_leave_time_in_minutes_from_now)
    self.save!
  end

  def format_trip_message
    "Leave now to catch the #{format_time(self.train_departing_time)} #{self.bart_line} train " +
    "from #{self.departure_station} to #{self.destination_station}. It's a #{self.walking_time} minute walk. <3, time2ghost"
  end

  def get_trips_for_current_minute
    BartTrip.where("recommended_leave_time = ?", Time.now.change(:sec => 0))
  end

  def format_fake_trip(minutes_until_ghosting)
    format_fake_trip_walking_time
    format_fake_trip_minutes(minutes_until_ghosting)
  end

  def format_fake_trip_walking_time
    depart_station_obj = get_station(self.departure_station)
    walk_time = get_walking_time_to_station(self.current_location, depart_station_obj.gmap_destination_string)
    self.update_attributes(:walking_time => walk_time)
    self.save
  end

  def format_fake_trip_minutes(minutes_until_ghosting)
    self.update_attributes(:recommended_leave_time => (Time.now + minutes_until_ghosting.to_i.minutes).change(:sec => 0))
    fake_depart_time = (Time.now + minutes_until_ghosting.to_i.minutes + self.walking_time.to_i.minutes + 5.minutes).change(:sec => 0)
    self.update_attributes(:train_departing_time => fake_depart_time)
  end

  def set_recommended_leave_time(suggested_leave_time_in_minutes_from_now)
    self.recommended_leave_time = remove_seconds_from_time(Time.now + suggested_leave_time_in_minutes_from_now.minutes)
  end

  def get_depart_times_and_line
    realtime_departures = RealtimeBartDepartures.new(self.departure_station, self.destination_station).get_departures
    self.bart_line = realtime_departures[:endpoint]
    @departures = realtime_departures[:departure_times]
  end

  def set_train_departing_time
    self.train_departing_time = remove_seconds_from_time(Time.now + number_to_minutes(@minutes_until_next_possible_train))
  end

  def get_minutes_until_train_departs # magic number 5 = get to the station 5 minutes early!
    @minutes_until_next_possible_train = @departures.find { |depart_time| depart_time.to_i - self.walking_time - 5 > 0 }.to_i
  end

  def get_station(abbr)
    Station.find_by_abbr(abbr.upcase)
  end

  def set_walking_time
    station_coordinates = Station.find_by_abbr(self.departure_station).gmap_destination_string
    self.walking_time = get_walking_time_to_station(current_location, station_coordinates)
  end

  def get_walking_time_to_station(origin, destination)
    GoogleMaps.new.http_get_directions(origin, destination).get_total_walking_time

    # gmaps_json = GoogleMaps.http_get_directions(origin, destination)
    # GoogleMaps.get_total_walking_time(gmaps_json)
  end
end
