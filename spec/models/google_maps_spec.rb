# encoding: utf-8
require 'spec_helper'

  describe GoogleMaps do
    let!(:stubbed_response) { GoogleMaps.new }
    let!(:stubbed_json) {JSON.parse(IO.read("spec/stubbed_gmaps_response.json"))}
    it "returns correct walking time" do
      stubbed_response.parsed_response = stubbed_json
      walking_time = stubbed_response.get_total_walking_time
      expect(walking_time).to eq(9)
    end


    it "returns correct parsed walking directions array" do
      stubbed_response.parsed_response = stubbed_json
      directions = stubbed_response.parse_directions
      expected = ["Head <b>south</b> on <b>Grant Ave</b> toward <b>Vinton Ct</b>", "Turn <b>left</b> onto <b>Post St</b>", "Turn <b>right</b> onto <b>Montgomery St</b>", "Turn <b>left</b> onto <b>Market St</b>"]
      expect(directions).to eq(expected)
    end

  end