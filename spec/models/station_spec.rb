require 'spec_helper'

describe Station do

  let!(:station) {Station.find_by_abbr("MONT")}

  context "#gmap_destination_string" do

    it "returns the correct lat&long of station in string form" do
      expect(station.gmap_destination_string).to eq("37.789256,-122.401407")
    end

  end

end