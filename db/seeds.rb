url_builder = BartURLBuilder.new("PITT", "24TH")
StationBuilder.new(url_builder.build_stations_api_call).create_all_stations