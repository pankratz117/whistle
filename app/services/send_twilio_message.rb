class SendTwilioMessage
  def initialize(alert)
    @alert = alert
    @account_sid = ENV['TWILIO_ACCOUNT_SID']
    @auth_token = ENV['TWILIO_TOKEN']
    @service_number = "+14193181678" # From Twilio
    @client = Twilio::REST::Client.new(@account_sid, @auth_token)
  end

  def send_alert
    @alert.user.responders.each do |responder|
      next if responder.phone_number.blank?

      send_message(@alert.kind, responder.phone_number, responder.name)
    end
  end

  # private

  def send_message(kind, to, responder_name)
    if kind == 'share'
      message = "Hey #{responder_name}, I'm using Whistle and this is where I'm heading : https://www.whistle-app.com/trips/15"
    elsif kind == 'whistle'
      message = "URGENT! #{responder_name} I NEED YOUR HELP, here is my current location: https://www.whistle-app.com/alerts/15"
    else
      message = "All good #{responder_name}, I reached my destination ! Thanks !"
    end
    @client.messages.create(
      from: @service_number,
      to: to,
      body: message
    )
  end
end
