class UserMailer < ApplicationMailer
  def registration_confirmation(company)
    recipients company.email
    from "webmaster@example.com"
    subject " Thank you for Registering"
    body :user => company
  end
end
