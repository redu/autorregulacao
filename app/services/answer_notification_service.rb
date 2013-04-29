class AnswerNotificationService
  include Virtus

  attribute :exercise, ArExercise
  attribute :question, Question

  def notify
    space_ws.users.each do |user|
      deliver_email(user)
    end
  end


  private

  def deliver_email(user)
    mail = AnswerMailer.
      new_answer(question: question, ar_exercise: exercise, user: user)

    begin
      mail.deliver
    rescue Exception
      Rails.logger.warn "There was an error delivering the e-mail"
    end

    mail
  end

  def space_ws
    @space_ws ||= SpaceRemoteService.
      new(resource: exercise.space, user: exercise.user)
  end
end
