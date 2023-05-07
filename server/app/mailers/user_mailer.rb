# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_reset_password_mail(email)
    mail(
      to: email
    )
  end
end
