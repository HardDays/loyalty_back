OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Twilio.configure do |config|
    config.account_sid = ENV["TWILIO_SID"] 
    config.auth_token = ENV["TWILIO_TOKEN"]
    ssl_verify_peer = false
end