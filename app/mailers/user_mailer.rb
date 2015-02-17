class UserMailer < ActionMailer::Base
  default from: "example@gmail.com"
  
  def send_new_user_message(val)
    @user = val
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

end
