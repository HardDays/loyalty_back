class PasswordMailer < ApplicationMailer
    def password_email(user, password_reset)
      @user = user
      @password_reset = password_reset
      mail(to: @user.email, subject: 'Восстановление пароля')
    end
end
