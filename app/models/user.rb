class User < ActiveRecord::Base
  has_many :ar_exercises, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :cooperations, dependent: :destroy

  attr_accessible :email, :login, :name, :token, :uid

  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.login = auth["info"]["login"]
      user.email = auth["info"]["email"]
      user.token = auth["credentials"]["token"]
    end
  end
end
