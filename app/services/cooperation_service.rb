class CooperationService
  include Virtus

  attribute :user, User
  attribute :cooperation, Cooperation

  def feedback_form
    FeedbackForm.new(user_id: user.id, id: cooperation.id)
  end

  def feedback?
    return false unless cooperation
    cooperation.feedback_statement && cooperation.feedback_reflection
  end
end
