class ArExercise < ActiveRecord::Base
  include HrefTo

  belongs_to :user
  belongs_to :space
  has_many :questions, dependent: :destroy

  attr_accessible :title
  serialize :representation
end
