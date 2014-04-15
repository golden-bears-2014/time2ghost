class BartTrip < ActiveRecord::Base
  attr_accessible :user_id, :departure_station, :destination_station, :walking_time, :directions,
  :train_departing_time, :bart_line, :recommended_leave_time, :current_location
  belongs_to :user
  include ApplicationHelper

  def update_departure_time
    set_walking_time
    get_depart_times_and_line
    get_minutes_until_train_departs
    set_train_departing_time
    set_recommended_leave_time
    self.save!
  end

  def set_walking_time
    station_coordinates = Station.find_by_abbr(self.departure_station).gmap_destination_string
    self.walking_time = get_walking_time_to_station(current_location, station_coordinates)
  end

  def get_depart_times_and_line
    @realtime_departures = RealtimeBartDepartures.new(self.departure_station, self.destination_station).get_departures
    p @realtime_departures
    puts "above here prank"
    # self.bart_line = @realtime_departures[:endpoint]
    # @departures = @realtime_departures[:departure_times]
  end

  # checks through the realtime departure hash
  # to find the earliest possible trip that the user can make
  def find_earliest_possible_departure_time
    @realtime_departure

  end

  def get_minutes_until_train_departs # magic number 5 = get to the station 5 minutes early!
    number_of_minutes_till_next_train = @departures.find { |depart_time| (depart_time.to_i - self.walking_time) >= 0 }
    puts number_of_minutes_till_next_train
    @minutes_until_next_possible_train = number_of_minutes_till_next_train.to_i
  end

  def set_train_departing_time
    self.train_departing_time = remove_seconds_from_time(Time.now + @minutes_until_next_possible_train.minutes)
  end

  def set_recommended_leave_time
    p self.recommended_leave_time = remove_seconds_from_time((Time.now + @minutes_until_next_possible_train.minutes) - 5.minutes - self.walking_time.minutes)

  end



  def format_trip_message
    "Leave now to catch the #{format_time(self.train_departing_time)} #{self.bart_line} train " +
    "from #{self.departure_station} to #{self.destination_station}. It's a #{self.walking_time} minute walk. <3, time2ghost"
  end

  def get_trips_for_current_minute
    BartTrip.where("recommended_leave_time = ?", Time.now.change(:sec => 0))
  end



  # def format_fake_trip(minutes_until_ghosting)
  #   @minutes_until_ghosting = minutes_until_ghosting.minutes
  #   set_walking_time
  #   format_fake_trip_minutes(minutes_until_ghosting)
  # end

  # def format_fake_trip_minutes
  #   fake_depart_time = remove_seconds_from_time(Time.now + @minutes_until_ghosting + number_to_minutes(self.walking_time) + 5.minutes)
  #   self.update_attributes(:recommended_leave_time => remove_seconds_from_time(Time.now + @minutes_until_ghosting))
  #   self.update_attributes(:train_departing_time => fake_depart_time)
  # end







  def get_walking_time_to_station(origin, destination)
    gmaps = GoogleMaps.new
    gmaps.http_get_directions(origin, destination)
    gmaps.get_total_walking_time
  end
end
