class InviteMailer < ActionMailer::Base
  default from: "contact@xulung.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite_mailer.send_invitation.subject
  #
  def send_invitation(email,token)
    @email=email
    @token=token
    mail(to: @email,subject: "Invitation")
  end

end
