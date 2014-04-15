require 'spec_helper'

describe BartTrip do
  before(:each) do
    @trip = BartTrip.new()
  end

  context "#find_closest_station" do

  it "finds the Powell station as closest to specified coords" do
    station = @trip.find_closest_station(37.779178, -122.406220)
    expect(station.abbr).to eq("POWL")
  end

  it "find the Montgomery station as closest to specified coords" do
    station = @trip.find_closest_station(37.792237, -122.406163)
    expect(station.abbr).to eq("MONT")
  end
end

  context "#set_recommended_leave_time" do
    it "sets recommended leave time correctly" do
      rand_minutes = rand(11)
      @trip.send(:set_recommended_leave_time, rand_minutes)
      expect(@trip.recommended_leave_time).to eq(Time.now.change(:sec => 0) + rand_minutes.minutes)
    end
  end

  context "#set_train_departing_time" do
    it "sets train departure time correctly" do
      test_minutes = 10
      @trip.send(:set_train_departing_time, test_minutes)
      expect(@trip.train_departing_time).to eq(Time.now.change(:sec => 0) + test_minutes.minutes)
    end
  end

  context "#get_station" do
    it "correctly gets a station" do
      expect(@trip.get_station("24TH")).to be_a(Station)
    end
  end

  context "#get_minutes_until_train_departs" do
    it "successfully gets potential departure times" do
      @trip.walking_time = 5
      potential_times = ["1", "10", "11"]
      expect(@trip.get_minutes_until_train_departs(potential_times)).to eq(11)
    end
  end

  context "#remove_seconds_from_time" do
    it "removes seconds from a given time" do
      seconds = rand(60)
      time = Time.new(2013, 6, 29, 10, 15, seconds)
      expect(@trip.remove_seconds_from_time(time)).to eq("2013-06-29 10:15:00 -0700")
    end
  end

  context "#get_trips_for_current_minute" do
    it "finds accurate trips for current minute" do

    BartTrip.create(:recommended_leave_time => Time.now.change(:sec => 0))
    expect(@trip.get_trips_for_current_minute.length).to eq(1)
    end
  end
end