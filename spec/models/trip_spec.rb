require 'spec_helper'

describe Trip do
  before(:each) do
    @trip = Trip.new
  end

  context "#find_closest_station" do

  it "finds the Powell station as closest to specified coords" do
    station = @trip.find_closest_station(37.779178, -122.406220)
    expect(station.abbr).to eq("POWL")
  end

  it "find the Montgomery station as closest to specified coords" do
    # feel a bit concernced that so many methods require taking a magically
    # built string or a pair of decimal numbers.  It seems to me that the
    # correct implementation is to `find_closest_station(a_geopair)`
    station = @trip.find_closest_station(37.792237, -122.406163)
    expect(station.abbr).to eq("MONT")
  end
end

  context "#set_recommended_leave_time" do
    it "sets recommended leave time correctly" do
      rand_minutes = rand(11)
      # Can you use .stub here instead?  This is kind of a gross
      # implementation.  It feels funny to use a random number in a test.  If
      # your test passes with a random number how are you actually testing
      # anything...?  Basically you're testing "this method should do something
      # and change things in the way that the something says."
      @trip.send(:set_recommended_leave_time, rand_minutes)
      expect(@trip.recommended_leave_time).to eq(Time.now.change(:sec => 0) + rand_minutes.minutes)
    end
  end

  context "#set_train_departing_time" do
    it "sets train departure time correctly" do
      rand_minutes = rand(11)
      @trip.send(:set_train_departing_time, rand_minutes)
      expect(@trip.train_departing_time).to eq(Time.now.change(:sec => 0) + rand_minutes.minutes)
    end
  end

  context "#get_station" do
    it "correctly gets a station" do
      # WHAT THE HELL IS THIS?
      #
      # Why aren't you just saying @trip.get_stations("24TH")
      #
      # And.....why are you even testing that?  You're testing whether
      # ActiveRecord works.
      expect(@trip.send(:get_station, "24TH")).to be_a(Station)
    end
  end

  context "#get_minutes_until_train_departs" do
    it "successfully gets potential departure times" do
      @trip.walking_time = 5
      potential_times = ["1", "10", "11"]
      # srsly, what's up with this #send thing?
      # Actually, what is this thing is testing?
      #
      # How does this return 11.  If it takes me 5 minutes to get there and a
      # train comes at 1 10 or 11 minutes from now...shouldn't I get the 10
      # minute one?  What?  Huh?  :(
      #
      # Come to think of it, why is this on Trip?  Does each and every Trip
      # ever created need to know how to calculate a time to departure?  Heck
      # no.
      expect(@trip.send(:get_minutes_until_train_departs, potential_times)).to eq(11)
    end
  end

  # Does not belong on trip
  context "#remove_seconds_from_time" do
    it "removes seconds from a given time" do
      seconds = rand(60)
      time = Time.new(2013, 6, 29, 10, 15, seconds)
      expect(@trip.send(:remove_seconds_from_time, time)).to eq("2013-06-29 10:15:00 -0700")
    end
  end

  # Does not belong here.
  context "#get_trips_for_current_minute" do
    it "finds accurate trips for current minute" do
    # Why are we doing this 5 times?
    5.times{ Trip.create(:recommended_leave_time => Time.now.change(:sec => 0))}
    expect(Trip.get_trips_for_current_minute.length).to eq(5)
    end
  end
end
