require 'spec_helper'

describe Station do

  let!(:station) {Station.find_by_abbr("MONT")}

  context "#distance_to" do

    it "gives correct lat&long difference for provided lat&long" do
      expect(station.distance_to(37.792197, -122.406146)).to eq(0.007680000000000575)
    end

  end

  context "#gmap_destination_string" do

    it "returns the correct lat&long of station in string form" do
      # I realy don't like this thing about where you're returning magical
      # strings.  You really should be returning an object that knows how to
      # provide these data.  This isn't a string but actually a GeospatialPair
      # or something like that.
      #
      # Looking at the call in Trip, you have a golden opportunity to invert
      # the dependency but merely passing a Station instance into the
      # `get_walking_time_to_station`
      expect(station.gmap_destination_string).to eq("37.789256,-122.401407")
    end

  end

end
