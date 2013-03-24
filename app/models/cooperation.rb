class Cooperation < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer
  validates :user_id, uniqueness: { scope: :answer_id }
  attr_accessible :feedback_accepted, :feedback_reflection, :feedback_statement, :rationale, :recommendation
end
