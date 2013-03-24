class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :cooperations, dependent: :destroy
  validates :user_id, uniqueness: { scope: :question_id }

  attr_accessible :initial, :rationale, :reflection
end
