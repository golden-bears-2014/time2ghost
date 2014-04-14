var Geolocate = function() {
  var binder = new Geolocate.Binder();
  binder.bind();
};

Geolocate.Binder = function() {
  this.controller = new Geolocate.Controller();
}

Geolocate.Binder.prototype = {

  bind: function() {
    this.bindGeolocate(this.controller);
  },

  bindGeolocate: function(controller) {
    $('#geolocateButton').on('click', function(){
      controller.getLocation();
    });
  }
};

Geolocate.Controller = function() {}

Geolocate.Controller.prototype = {
  getLocation: function(){
    if ("geolocation" in navigator){
      navigator.geolocation.getCurrentPosition(this.onSuccess, this.showError);
    }
    else {
      alert('Geolocation is not supported in your browser.');
    }
  },

  onSuccess: function(position){
    Geolocate.Controller.prototype.reverseGeolocation(position)
  },

  reverseGeolocation: function(position){
    var coords = position.coords.latitude + "," + position.coords.longitude;
    $.ajax({
      type: 'GET',
      url: "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + coords + "&sensor=false"

    }).done(function(response){
      var address = response.results[0].formatted_address
      $("#geolocateButton").html("Found you :)");
      $("#trip_current_location").val(address);
    })
  },

  showError: function(error) {
    switch(error.code) {
      case error.PERMISSION_DENIED:
        alert("User denied the request for Geolocation.");
        break;
      case error.POSITION_UNAVAILABLE:
        alert("Location information is unavailable.");
        break;
      case error.TIMEOUT:
        alert("The request to get user location timed out.");
        break;
      case error.UNKNOWN_ERROR:
        alert("An unknown error occurred.");
        break;
    }
  }
};

$(document).ready(function(){
  geoloc = new Geolocate();

});

