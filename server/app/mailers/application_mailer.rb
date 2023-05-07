# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'scm.myattheingiaung@example.com'
  layout 'mailer'
end
