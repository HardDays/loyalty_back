class User < ApplicationRecord

    has_secure_password

    has_one :user_confirmation
    has_one :company_info

    # в базе хранится как integer, но можно обращаться как к строке или символу,
    # магия рельс
    # создатель команиии или кассир
    enum user_type: [:creator, :operator]

    validates :email, presence: true, length: {maximum: 255}, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}
    validates :password, presence: true, confirmation: true, length: {minimum: 7}, if: lambda { |m| m.password.present? }

    # проверка на нулл
    validates :user_type, inclusion: {in: User.user_types.keys}

    # поиск юзера по токену
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

    # токен для аутентификации
    def token
        payload = {
            user_id: id,
            exp: 24.hours.from_now.to_i
        }
        return JWT.encode(payload, Rails.configuration.token_salt)
    end
    
    # тут форматируется жсон ответ
    def serializable_hash(options = {})
        attrs = super
        
        # отправлять токен при авторизации
        if options
            if options[:token]
                attrs[:token] = token
            end
        end
        # выпилить пароль из результата для секурности
        super.merge(attrs).except('password_digest')
    end
end
