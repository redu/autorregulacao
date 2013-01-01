class AnswerService
  include Virtus

  attribute :user, User
  attribute :answer, Answer

  # Returns true the user didn't answer. If there is no user specified, it returns
  # true if anyone answered.
  def open?
    !scoped_cooperations.exists?
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
