class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :cooperations, dependent: :destroy

  attr_accessible :initial, :rationale, :reflection
end
