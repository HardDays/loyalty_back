class ConfirmationMailer < ApplicationMailer
    def confirmation_email(user)
      if Rails.env.development?
        @user = user
        mail(to: @user.email, subject: 'Подтверждение почты')
      end
    end
end
