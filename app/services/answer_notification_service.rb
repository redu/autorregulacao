class AnswerNotificationService
  include Virtus

  attribute :exercise, ArExercise
  attribute :question, Question

  def notify
    space_ws.users.each do |user|
      mail = AnswerMailer.
        new_answer(question: question, ar_exercise: exercise, user: user)
      mail.deliver
    end
  end

  private

  def deliver_email(user)
    AnswerMailer.new_answer(question, user).deliver
  end

  def space_ws
    @space_ws ||= SpaceRemoteService.
      new(resource: exercise.space, user: exercise.user)
  end
end
