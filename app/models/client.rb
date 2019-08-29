class Client < ApplicationRecord
  has_secure_password

  belongs_to :company

  validates :phone, presence: true, length: {maximum: 255}
  validates :password, presence: true, confirmation: false, length: {minimum: 7}, if: lambda { |m| m.password.present? }

  def self.authorize(token)
    payload = nil
    begin
      payload = JWT.decode(token, Rails.configuration.token_salt)[0]
      client = Client.find(payload['client_id'])
      return client
    rescue => ex
      raise ApplicationController::Unauthorized
    end
  end

  def token
    payload = {
        client_id: id,
        exp: 24.hours.from_now.to_i
    }
    return JWT.encode(payload, Rails.configuration.token_salt)
  end

  def serializable_hash(options = {})
    attrs = super

    super.merge(attrs).except('password_digest')
  end
end
