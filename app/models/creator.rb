class Creator < ApplicationRecord
  has_secure_password

  has_one :creator_confirmation
  has_one :company

  validates :email, presence: true, length: {maximum: 255}, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, presence: true, confirmation: true, length: {minimum: 7}, if: lambda { |m| m.password.present? }

  def self.authorize(token)
    payload = nil
    begin
      payload = JWT.decode(token, Rails.configuration.token_salt)[0]
      creator = Creator.find(payload['creator_id'])
      return creator
    rescue => ex
      raise ApplicationController::Unauthorized
    end
  end

  def token
    payload = {
        creator_id: id,
        exp: 24.hours.from_now.to_i
    }
    return JWT.encode(payload, Rails.configuration.token_salt)
  end

  def serializable_hash(options = {})
    attrs = super

    if options
      if options[:token]
        attrs[:token] = token
      end
    end

    super.merge(attrs).except('password_digest')
  end
end
