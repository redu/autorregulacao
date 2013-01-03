class FeedbackForm < BaseForm
  attr_reader :cooperation

  attribute :user_id, Integer
  attribute :id, Integer
  attribute :feedback_statement, String
  attribute :feedback_reflection, String
  attribute :feedback_accepted, Boolean

  validates :feedback_statement, :feedback_reflection, :user_id, :id, presence: true
  validates_inclusion_of :feedback_accepted, :in => [true, false]

  def persist!
    attrs = { feedback_statement: feedback_statement,
              feedback_reflection: feedback_reflection,
              feedback_accepted: feedback_accepted }
    cooperation.update_attributes(attrs)
  end

  def cooperation
    Cooperation.find_by_id(id)
  end
end
