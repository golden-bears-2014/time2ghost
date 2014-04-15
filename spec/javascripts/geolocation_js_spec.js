describe ("Geolocate", function() {
  it("is defined", function() {
    expect(Geolocate).toBeDefined();
  }),

  it("has a Controller", function() {
    expect(Geolocate.Controller).toBeDefined();
  }),

  it("has a Binder", function() {
    expect(Geolocate.Binder).toBeDefined();
  }),

  it("", function() {

  })
});

describe ("Geolocate.Controller", function() {
  it("gets address from reverseGeolocation", function() {
    var position = {
      coords: {
        latitude: 37.784598,
        longitude: -122.397218
      }
    }
    expect(reverseGeolocation(position)).toBeUndefined
  })
});

describe ("BartStations", function() {
  it("is defined", function() {
    expect(BartStations).toBeDefined();
  })
});