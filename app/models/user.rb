class User < ActiveRecord::Base
  has_many :urls

  def self.authenticate(given_email, given_password)
    user = User.where("email = ? AND password = ?", given_email, given_password).first
    return user
  end
end
