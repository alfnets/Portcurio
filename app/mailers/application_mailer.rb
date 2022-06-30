class ApplicationMailer < ActionMailer::Base
  default from: "noreply@mail.#{ApplicationController.helpers.domain_name}"
  layout 'mailer'
end
