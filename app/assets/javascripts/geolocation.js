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
        $('#geolocateButton').on('click', function() {
            controller.getLocation();
        });
    }
};

Geolocate.Controller = function() {}

Geolocate.Controller.prototype = {
    getLocation: function() {
        if ("geolocation" in navigator) {
            navigator.geolocation.getCurrentPosition(this.onSuccess, this.showError);
        } else {
            alert('Geolocation is not supported in your browser.');
        }
    },

    onSuccess: function(position) {
        Geolocate.Controller.prototype.reverseGeolocation(position)
    },

    reverseGeolocation: function(position) {
        var coords = position.coords.latitude + "," + position.coords.longitude;
        $.ajax({
            type: 'GET',
            url: "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + coords + "&sensor=false&key=AIzaSyBxh8vE1E5HfT5-TYUMWKcuR-ojA77G65U"
        }).done(function(response) {
            var address = response.results[0].formatted_address
            $("#geolocateButton").html("Found you and closest departure station :)");
            $("#bart_trip_current_location").val(address);
            var bStations = new BartStations();
            bStations.getClosestBart(position.coords.latitude, position.coords.longitude);
        }).fail(function(response, error) {
            console.log(error);
        });
    },

    showError: function(error) {
        switch (error.code) {
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

var BartStations = function() {

};

BartStations.prototype = {

    getClosestBart: function(userLatitude, userLongitude) {
        $.ajax({
            type: 'GET',
            url: "/stations"
        }).done(function(response) {
            var closestStationAbbr = this.algorithmFindClosest(response, userLatitude, userLongitude);
            $('#bart_trip_departure_station').val(closestStationAbbr)
        }.bind(this));
    },

    algorithmFindClosest: function(stations, userLatitude, userLongitude) {
        var differencesArray = this.getArrayOfDifferences(stations, userLatitude, userLongitude);
        var indexOfSmallest = this.findIndexOfSmallestElement(differencesArray);

        return stations[indexOfSmallest]["abbr"];
    },

    getArrayOfDifferences: function(stations, userLatitude, userLongitude) {
        var differences = [];
        for (var stationIndex in stations) {
            var latDiff = Math.abs(userLatitude - stations[stationIndex]["latitude"]);
            var longDiff = Math.abs(userLongitude - stations[stationIndex]["longitude"]);
            differences[stationIndex] = latDiff + longDiff;
        }

        return differences;
    },

    findIndexOfSmallestElement: function(differencesArray) {
        var smallest = differencesArray[0];
        var smallestIndex = 0
        for (var diffIndex in differencesArray) {
            if (differencesArray[diffIndex] < smallest) {
                smallest = differencesArray[diffIndex];
                smallestIndex = diffIndex;
            }
        }

        return smallestIndex;
    }
}

$(document).ready(function() {
    geoloc = new Geolocate();
});