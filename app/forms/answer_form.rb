class AnswerForm < BaseForm
  attr_reader :question, :user, :answer

  attribute :question_id, Integer
  attribute :user_id, Integer
  attribute :initial, String
  attribute :rationale, String
  attribute :reflection, String

  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :initial, presence: true
  validates :rationale, presence: true
  validates :reflection, presence: true

  def persist!
    attrs = { initial: initial, rationale: rationale, reflection: reflection }
    @answer = question.answers.create(attrs) do |answer|
      answer.user = user
    end
  end

  def question
    @question ||= Question.find_by_id(question_id)
  end

  def user
    @user ||= User.find_by_id(user_id)
  end
end
