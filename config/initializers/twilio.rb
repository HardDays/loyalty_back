OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Twilio.configure do |config|
    config.account_sid = 'AC086e4c4190a2eaf9125e76db8ef3d9fc'
    config.auth_token = '5519c4107e48c7253ad9ebcf83b3b726'
    ssl_verify_peer = false
end