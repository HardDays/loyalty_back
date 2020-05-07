class ConfirmationMailer < ApplicationMailer
    def confirmation_email(user)
      if Rails.env.development? || Rails.env.production?
        @user = user
        mail(to: @user.email, subject: 'Подтверждение почты')
      end
    end
end
