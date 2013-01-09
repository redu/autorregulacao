# encoding: UTF-8
class ArExerciseForm < BaseForm
  attr_reader :ar_exercise
  attribute :title, String
  attribute :user_id, Integer
  attribute :questions, Array

  validates :questions, length: { is: 3 }
  validates :title, :user_id, presence: true

  def valid?
    if questions_form.collect(&:valid?).reduce(:&)
      super
    else
      #FIXME add real question errors
      errors.add :base, 'as questões devem estar completas'
      false
    end
  end

  def persist!
    @ar_exercise = ArExercise.create(title: title) do |e|
      e.user = user
    end
    questions_form(ar_exercise_id: ar_exercise.id).collect(&:save)

    @ar_exercise
  end

  def questions_form(attrs={})
    @questions_form ||= questions.collect do |i|
      QuestionForm.new(attrs.merge(i))
    end
  end

  def user
    @user = User.find_by_id(user_id)
  end
end
