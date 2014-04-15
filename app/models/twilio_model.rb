class TwilioMessage

  def self.send_text(trip_message)
  @client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_AUTH'])
  @client.account.messages.create(
    :from => '+14155211220',
    :to => "+1#{trip_object.user.phone_number}",
    :body => trip_message
)
  end

  def self.send_all_texts_for_now
    trips = BartTrip.get_trips_for_current_minute
    trips.each {|trip| TwilioMessage.send_text(trip.trip_message)}
  end

  def self.text_test
    @client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_AUTH'])
    @client.account.messages.create(
    :from => '+14155211220',
    :to => "+18184212905",
    :body => "hi it's #{Time.now}"
)
  end
end