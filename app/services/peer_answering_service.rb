class PeerAnsweringService < QuestionService
  def pending
    questions = question.ar_exercise.try(:questions) || [question]
    #FIXME should be done by a constant number of SQL queries
    first_cooperation_by_user = Answer.select('id, user_id').
      where(question_id: questions).select do |answer|
        coop = answer.cooperations.select('id, user_id').
          order('cooperations.created_at ASC').first
        coop && (coop.user_id == user.id)
      end

    question.answers.where(user_id: first_cooperation_by_user.map(&:user_id))
  end
end
