class User < ApplicationRecord

    has_secure_password

    has_one :creator_confirmation
    has_one :company

    enum user_type: [:creator, :operator, :client]

    validates :email, presence: true, length: {maximum: 255}, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}
    validates :password, presence: true, confirmation: true, length: {minimum: 7}, if: lambda { |m| m.password.present? }

    validates :user_type, inclusion: {in: User.user_types.keys}

    def self.authorize(token)
        payload = nil
        begin
            payload = JWT.decode(token, Rails.configuration.token_salt)[0]
            user = User.find(payload['user_id'])
            return user
        rescue => ex
            raise ApplicationController::Unauthorized
        end
    end

    def token
        payload = {
            user_id: id,
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
