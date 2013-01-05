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

  # Yields to AnswerService instances bounded to each answer and user.
  # It returns a collect of AnswerService if there is no block.
  #
  # where: conditions passed to the query. Accepts the same option as
  # ActiveRecord::FinderMethods#where
  def answer_services(opts={}, &block)
    conditions = opts.fetch(:where, {})

    block_given = block_given?
    answers.where(conditions).collect do |a|
      service = AnswerService.new(answer: a, user: user)
      yield(service) if block_given
      service
    end
  end

  private

  # Returns the answer if it exists
  def answer
    question.answers.find(:first, conditions: { user_id: user.id })
  end

  # Returns the list of answers for this question.
  def answers
    question.answers
  end
end
