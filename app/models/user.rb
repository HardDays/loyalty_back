class User < ApplicationRecord

    enum gender: [:male, :female]

    has_secure_password

    has_one :operator, dependent: :destroy
    has_one :creator, dependent: :destroy
    has_one :client, dependent: :destroy
    has_one :user_confirmation, dependent: :destroy

    validates :email, length: {maximum: 255}, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, if: lambda { |m| !m.phone.present? }
    validates :phone, length: {maximum: 32}, uniqueness: {case_sensitive: false}, presence: true, if: lambda { |m| !m.email.present? }
    validates :password, presence: true, confirmation: true, length: {minimum: 7, maximum: 128}, if: lambda { |m| m.password.present? }

    validates :first_name, length: {minimum: 1, maximum: 128}
    validates :last_name, length: {minimum: 1, maximum: 128}
    validates :second_name, length: {minimum: 0, maximum: 128}, allow_nil: true

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

    def role(value)
        if value == nil
            raise ApplicationController::Forbidden
        end
    end

    def roles(value)
        if value.all?{|v| v == nil}
            raise ApplicationController::Forbidden
        end
    end

    def company
        if creator
            return creator.company
        else
            return operator.company
        end
    end

    def creator_permission(value)
        if !(value && value.company == self.creator.company)
            raise ApplicationController::Forbidden
        end
    end

    def operator_permission(value)
        if !(value && value.company == self.operator.company && self.operator.operator_status != 'deleted')
            raise ApplicationController::Forbidden
        end
    end

    def token
        payload = {
            user_id: id,
            exp: 7.days.from_now.to_i
        }
        return JWT.encode(payload, Rails.configuration.token_salt)
    end
    
    def as_json(options = {})
        attrs = super
        
        if options
            if options[:token]
                attrs[:token] = token
            end
        end
        if client
            attrs = attrs.merge(client.as_json(options))
        elsif creator
            attrs = attrs.merge(creator.as_json(options))
        elsif operator
            attrs = attrs.merge(operator.as_json(options))
        end

        return attrs.except('password_digest')
    end
end
