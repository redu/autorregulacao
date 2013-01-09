# encoding: UTF-8
class ArExerciseForm < BaseForm
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

  def questions_form
    @questions_form ||= questions.collect { |i| QuestionForm.new(i) }
  end
end
