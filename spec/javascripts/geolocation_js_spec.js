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

// This is working. Waits for the call in the code to
// beforeEach(function(done) {
//     setTimeout(function() {
//       value = 0;
//       done();
//     }, 1);
//   });
describe ("Geolocate.Controller", function() {
  // it("is defined", function(done) {
  it("is defined", function() {
    expect(Geolocate.Controller).toBeDefined();
    // var position = {
    //   coords: {
    //     latitude: 37.784598,
    //     longitude: -122.397218
    //   }
    // }
    // var a = Geolocate.Controller.prototype.reverseGeolocation(position);
    // console.log(a + "hi");
    // done();
    // // waitsFor(reverseGeolocation(position), 2000);

    // // console.log(response)
  })
});


describe ("BartStations", function() {
  it("is defined", function() {
    expect(BartStations).toBeDefined();
  })
});