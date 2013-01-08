class QuestionForm < BaseForm
  attribute :title, String
  attribute :statement, String
  attribute :ar_exercise_id, Integer

  validates :title, :statement, presence: true

  def ar_exercise
    @ar_exercise ||= ArExercise.find_by_id(ar_exercise_id)
  end

  def persist!
    ar_exercise.questions.create(title: title, statement: statement)
  end
end
