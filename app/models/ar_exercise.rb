class ArExercise < ActiveRecord::Base
  belongs_to :user
  has_many :questions, dependent: :destroy

  attr_accessible :title
end
