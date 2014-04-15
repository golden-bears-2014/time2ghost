require 'spec_helper'
require 'fixtures/fixtures'

describe RealtimeBartDepartures do
  context "#parse_route_xml" do
    it "returns the correct route" do
      expect(RealtimeBartDepartures.parse_route_xml(ROUTE_XML)).to eq("ROUTE 2")
    end
  end

  context "#parse_endpoint_xml" do
    it "returns the correct endpoint" do
      expect(RealtimeBartDepartures.parse_endpoint_xml(ENDPOINT_XML)).to eq("SFIA")
      end
    end

  context "#parse_realtime_departure_xml" do
    it "returns realtime departure data" do
      expect(RealtimeBartDepartures.parse_realtime_departure_xml(REALTIME_XML, "DALY")).to eq(["11", "14", "25", "DALY"])
    end
  end
end