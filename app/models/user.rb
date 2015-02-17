class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable
  validate  :email_regex
  devise :omniauthable, :omniauth_providers => [:facebook]
  after_create :send_admin_mail

  def send_admin_mail
    UserMailer.send_new_user_message(self).deliver
  end

   def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      # user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def email_regex
    flag = 0
    comp = Company.uniq.pluck(:email_format)
    comp.each do |com|
      if email.present? and email.include? com
        flag = 1
        break
      end
    end
    unless flag == 1
      errors.add :email, " is not a valid"
    end
  end

end
