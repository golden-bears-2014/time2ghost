class TwilioController < ApplicationController
  # What is this doing?  Generating a random trip?  I think that's what
  # this is doing?  It feels like there should be a TripCalculator class to
  # help this out.  What.  I.  don't... no.  I give up.
  def show
      first = ["RICH", "LAKE", "GLEN", "POWL", "FRMT", "MLBR", "LAFY", "DUBL", "CIVC", "BAYF", "COLS", "CAST", "SBRN"].sample
      second = ["RICH", "LAKE", "GLEN", "POWL", "FRMT", "MLBR", "LAFY", "DUBL", "CIVC", "BAYF", "COLS", "CAST", "SBRN"].sample

      bart = Bart.get_departures(first, second)
      # What is this doing?  And why isn't the Bart instance's get_departures
      # doing this?  SEcondly, what the hell is that Bart class doing?  It's
      # covering tons of things?  I don't get it.
      #
      # Why is all this random gen stuff going on in the controller?  Why was
      # it committed?
      bart.map!{|x| x + " minutes. "}
      @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH']
      @client.account.messages.create(
       :from => '+14155211220',
       :to => '+18184212905',
       :body => "times from #{first} to #{second}: #{bart}"
      )
  end
end
