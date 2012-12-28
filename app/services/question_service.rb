# Responsible for the actions associated with Questions.
class QuestionService
  include Virtus

  attribute :question, Question
  attribute :user, User
  attribute :answer_form, AnswerForm

  # Builds a AnswerForm and bound the question and user passed to this class.
  # If a AnswerForm was passed to the initializer, thins one is returned
  def answer_form
    @answer_form ||= AnswerForm.new(question_id: question.id, user_id: user.id)
  end

  # Returns true if the user answered the question already
  def answered?
    question.answers.exists?(user_id: user.id)
  end

  # Returns the answer if it exists
  def answer
    question.answers.find(:first, conditions: { user_id: user.id })
  end
end
