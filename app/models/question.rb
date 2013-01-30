class Question < ActiveRecord::Base
  belongs_to :ar_exercise
  has_many :answers, dependent: :destroy
  attr_accessible :statement, :title, :position
end
