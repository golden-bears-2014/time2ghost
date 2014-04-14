/* OH my goodness, how is this so nice, but forms.js so painful? */


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
    var coords = position.coords.latitude + "," + position.coords.longitude;
    $("#trip_current_location").val(coords);
    $("#geolocateButton").html("Found you :)");
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
  // Does anyone actually use the window.geoloc object?
  geoloc = new Geolocate();
});

