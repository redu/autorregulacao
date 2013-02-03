class Question < ActiveRecord::Base
  include HrefTo

  belongs_to :ar_exercise
  has_many :answers, dependent: :destroy
  attr_accessible :statement, :title, :position
  serialize :representation
end
