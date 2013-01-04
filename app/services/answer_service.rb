class AnswerService
  include Virtus

  attribute :user, User
  attribute :answer, Answer

  # Returns true the user answered. If there is no user specified, it returns
  # true if anyone answered.
  def cooperated?
    return false unless user
    cooperation != nil
  end

  def initiator?
    user == answer.user
  end

  # Returns a QuestionService instance bounded to #answer.question
  def question_service
    QuestionService.new(question: answer.question, user: user)
  end

  def cooperation_services(&block)
    @block = block
    answer.cooperations.each do |c|
      @block.call CooperationService.new(cooperation: c, user: user)
    end
  end

  def cooperation
    answer.cooperations.find(:first, conditions: { user_id: user })
  end
end
