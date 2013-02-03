class ArExercise < ActiveRecord::Base
  belongs_to :user
  belongs_to :space
  has_many :questions, dependent: :destroy

  attr_accessible :title
  serialize :representation
end
