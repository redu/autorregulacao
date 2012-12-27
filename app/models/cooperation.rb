class Cooperation < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer
  attr_accessible :feedback_accepted, :feedback_reflection, :feedback_statement, :rationale, :recommendation
end
