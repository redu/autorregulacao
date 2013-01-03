class AnswerService
  include Virtus

  attribute :user, User
  attribute :answer, Answer

  # Returns true the user answered. If there is no user specified, it returns
  # true if anyone answered.
  def cooperated?
    return false unless user
    scoped_cooperations.exists?
  end

  def initiator?
    user == answer.user
  end

  protected

  def scoped_cooperations
    if user
      answer.cooperations.where("cooperations.user_id == ?", user)
    else
      answer.cooperations
    end
  end
end
