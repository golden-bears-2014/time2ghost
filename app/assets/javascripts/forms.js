$( function() {
      $("#user_submit").prop("disabled", true); // disable the submit button
      $("#user_phone_number").formance("format_phone_number") // setup the formatter
                             .on( 'keyup change blur', function (event) { // setup the event listeners to validate the field whenever the user takes an action
                               if ( $(this).formance('validate_phone_number') && ($('#user_email').formance('validate_email')))
                                 $("#user_submit").prop("disabled", false); // enable the submit button if valid phone number
                               else
                                 $("#user_submit").prop("disabled", true); // disable the submit button if invalid phone number
                             });

      $("#user_email").formance("format_email")
                            .on( 'keyup change blur', function (event) {
                              if ( $(this).formance('validate_email') && $('#user_phone_number').formance('validate_phone_number') )
                                  $("#user_submit").prop("disabled", false); // enable the submit button if valid phone number
                               else
                                 $("#user_submit").prop("disabled", true); // disable the submit button if invalid phone number
                             });


    });

$(document).on('click', '#geolocateButton', function(){
  $(this).prop("disabled", true)
  $(this).html("Finding you...")
})
