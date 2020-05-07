class PasswordMailer < ApplicationMailer
    def password_email(user, password)
      if Rails.env.development? || Rails.env.production?
        @user = user
        @password = password
        mail(to: @user.email, subject: 'Пароль от лояльности')
      end
    end
end
