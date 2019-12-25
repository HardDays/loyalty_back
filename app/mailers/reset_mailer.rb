class ResetMailer < ApplicationMailer
    def reset_email(user, confirmation)
      @user = user
      @confirmation = confirmation
      mail(to: @user.email, subject: 'Код подтверждения')
    end
end
