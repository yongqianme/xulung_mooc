# Preview all emails at http://localhost:3000/rails/mailers/welcome
class WelcomePreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/welcome/welcome_greetings
  def welcome_greetings
    Welcome.welcome_greetings
  end

end
