require 'spec_helper'

describe BartURLBuilder do
    before :each do
      @bartURLbuilder = BartURLBuilder.new("24TH", "PITT")
    end

  context "#build_routes_api_call" do
    it "builds the routes api call correctly" do
      expect(@bartURLbuilder.build_routes_api_call).to eq("http://api.bart.gov/api/sched.aspx?cmd=depart&orig=24TH&dest=PITT&key=MW9S-E7SL-26DU-VV8V")
    end
  end

context "#build_endpoint_api_call" do
    it "builds the endpoint api call correctly" do
      expect(@bartURLbuilder.build_endpoint_api_call("2")).to eq("http://api.bart.gov/api/route.aspx?cmd=routeinfo&route=2&key=MW9S-E7SL-26DU-VV8V")
    end
  end

  context "#build_realtime_departures_api_call" do
    it "builds the realtime departures api call correctly" do
      expect(@bartURLbuilder.build_realtime_departures_api_call).to eq("http://api.bart.gov/api/etd.aspx?cmd=etd&orig=24TH&key=MW9S-E7SL-26DU-VV8V")
    end
  end

end