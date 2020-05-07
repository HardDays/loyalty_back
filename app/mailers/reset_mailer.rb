class ResetMailer < ApplicationMailer
    def reset_email(user, confirmation)
      if Rails.env.development? || Rails.env.production?
        @user = user
        @confirmation = confirmation
        mail(to: @user.email, subject: 'Код подтверждения')
      end
    end
end
