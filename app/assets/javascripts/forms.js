$(document).on('click', '#geolocateButton', function() {
    $("#geolocateButton").prop("disabled", true);
    $("#geolocateButton").html("Locating you...");
})