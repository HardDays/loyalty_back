class PasswordMailer < ApplicationMailer
    def password_email(user, password)
      @user = user
      @password = password
      mail(to: @user.email, subject: 'Пароль от лояльности')
    end
end
