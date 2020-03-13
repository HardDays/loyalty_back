class User < ApplicationRecord

    enum gender: [:male, :female]

    has_secure_password

    # has_one :operator, dependent: :destroy
    # has_one :creator, dependent: :destroy
    # has_one :client, dependent: :destroy
    has_many :operators, dependent: :destroy
    has_many :creators, dependent: :destroy
    has_many :clients, dependent: :destroy
    
    has_one :user_confirmation, dependent: :destroy 

    # validates :email, length: {maximum: 255}, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, if: lambda { |m| !m.phone.present? || (m.email.present? && m.phone.present?) }
    # validates :phone, phone: true, uniqueness: true, presence: true, if: lambda { |m| !m.email.present? || (m.email.present? && m.phone.present?) }
    validates :email, length: {maximum: 255}, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true
    validates :phone, phone: true, uniqueness: true, presence: true
    validates :password, presence: true, confirmation: true, length: {minimum: 7, maximum: 128}, if: lambda { |m| m.password.present? }

    validates :first_name, length: {minimum: 1, maximum: 128}
    validates :last_name, length: {minimum: 1, maximum: 128}
    validates :second_name, length: {minimum: 0, maximum: 128}, allow_nil: true

    before_validation :format_phone

    def format_phone
        if self.phone
            phone = Phonelib.parse(self.phone)
            self.phone = phone.valid? ? phone.sanitized : phone.original
        end
    end

    # def company
    #     if creator
    #         return creator.company
    #     else
    #         return operator.company
    #     end
    # end

    def token
        payload = {
            user_id: id,
            exp: 90.days.from_now.to_i
        }
        return JWT.encode(payload, Rails.configuration.token_salt)
    end

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

    def creator(company)
        begin
            return creators.where(id: company.creator_id).first
        rescue => ex
        end
    end

    def operator(company)
        begin
            return operators.where(company_id: company.id, operator_status: :active).first
        rescue => ex
        end
    end

    def any_operator(company)
        begin
            return operators.where(company_id: company.id).first
        rescue => ex
        end
    end

    def client(company)
        begin
            return clients.where(company_id: company.id).first
        rescue => ex
        end
    end

    def company_creator?(company)
        if !creator(company)
            raise ApplicationController::Forbidden
        end
    end

    def company_operator?(company)
        if !operator(company)
            raise ApplicationController::Forbidden
        end
    end

    def company_operator_creator?(company)
        if !operator(company) && !creator(company)
            raise ApplicationController::Forbidden
        end
    end

    def company_client?(company)
        if !client(company)
            raise ApplicationController::Forbidden
        end
    end

    #TODO: refactor

    # def role(value)
    #     if !value
    #         raise ApplicationController::Forbidden
    #     end
    # end

    # def roles(value)
    #     if value.all?{|v| !v}
    #         raise ApplicationController::Forbidden
    #     end
    # end
    
    # def creator_role
    #     return self.creator != nil
    # end

    # def operator_role
    #     return self.operator != nil && self.operator.operator_status != 'deleted'
    # end

    # def client_role
    #     return self.client != nil
    # end
    
    # def permission(value, current)
    #     if !(value && current && value.company == current.company)
    #         raise ApplicationController::Forbidden
    #     end
    # end

    # def permissions(value, current)
    #     if !(value && current && current.all?{|c| c && c.company != value.company})
    #         raise ApplicationController::Forbidden
    #     end
    # end

    # def creator_permission(value)
    #     self.permission(value, self.creator)
    # end

    # def operator_permission(value)
    #     operator_role
    #     if !(value && value.company == self.operator.company && self.operator_role)
    #         raise ApplicationController::Forbidden
    #     end
    # end

    # def creator_permission(value)
    #     if !(value && value.company == self.creator.company)
    #         raise ApplicationController::Forbidden
    #     end
    # end

    # def operator_permission(value)
    #     if !(value && value.company == self.operator.company && self.operator.operator_status != 'deleted')
    #         raise ApplicationController::Forbidden
    #     end
    # end
    
    def as_json(options = {})
        attrs = super
        
        if options
            if options[:token]
                attrs[:token] = token
            end
        end
        
        attrs[:client] = clients.as_json(options)
        attrs[:operator] = operators.as_json(options)
        attrs[:creator] = creators.as_json(options)


        # attrs[:user_types] = []
        # if client
        #     attrs = attrs.merge(client.as_json(options))
        #     attrs[:user_types] << :client
        # end
        # if creator
        #     attrs = attrs.merge(creator.as_json(options))
        #     attrs[:user_types] << :creator
        # end
        # if operator && operator.operator_status != 'deleted'
        #     attrs = attrs.merge(operator.as_json(options))
        #     attrs[:user_types] << :operator
        # end




        return attrs.except('password_digest')
    end
end
