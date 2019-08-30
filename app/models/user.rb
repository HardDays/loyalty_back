class User < ApplicationRecord

    has_secure_password

    has_one :operator, dependent: :destroy
    has_one :creator, dependent: :destroy
    has_one :client, dependent: :destroy
    has_one :user_confirmation, dependent: :destroy

    #TODO: validations

    validates :email, length: {maximum: 255}, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, if: lambda { |m| !m.phone.present? }
    validates :phone, length: {maximum: 32}, uniqueness: {case_sensitive: false}, presence: true, if: lambda { |m| !m.email.present? }
    validates :password, presence: true, confirmation: true, length: {minimum: 7}, if: lambda { |m| m.password.present? }

    validates :first_name, length: {minimum: 1, maximum: 128}
    validates :last_name, length: {minimum: 1, maximum: 128}
    validates :second_name, length: {minimum: 1, maximum: 128}, allow_nil: true

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

    def permission(value)
        if value == nil
            raise ApplicationController::Forbidden
        end
    end

    def creator_check(creator)
        if !(self.operator && self.operator.company == creator.company)
            raise ApplicationController::Forbidden
        end
    end

    def operator_check(operator)
        if !(self.client && self.client.company == operator.company)
            raise ApplicationController::Forbidden
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
