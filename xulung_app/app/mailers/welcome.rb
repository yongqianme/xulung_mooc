class Welcome < ActionMailer::Base
  default from: "contact@xulung.com"

  def welcome_greetings(user)
    @hello=user.username
    mail to: user.email
  end

  def welcome_promotion(user)
    @hello=user.username
    mail subject: "诩阆和您计划2016",
         to: user.email
  end

end
