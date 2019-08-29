class Operator < ApplicationRecord
  has_secure_password
  
  belongs_to :store
  belongs_to :company

  validates :email, presence: true, length: {maximum: 255}, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, presence: true, confirmation: true, length: {minimum: 7}, if: lambda { |m| m.password.present? }

  def self.authorize(token)
    payload = nil
    begin
      payload = JWT.decode(token, Rails.configuration.token_salt)[0]
      operator = Operator.find(payload['operator_id'])
      return operator
    rescue => ex
      raise ApplicationController::Unauthorized
    end
  end

  def token
    payload = {
        operator_id: id,
        exp: 24.hours.from_now.to_i
    }
    return JWT.encode(payload, Rails.configuration.token_salt)
  end

  def serializable_hash(options = {})
    attrs = super

    super.merge(attrs).except('password_digest')
  end
end
