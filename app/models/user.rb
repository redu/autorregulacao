class User < ActiveRecord::Base
  has_many :ar_exercises, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :cooperations, dependent: :destroy

  attr_accessible :email, :login, :name, :token, :uid
end
