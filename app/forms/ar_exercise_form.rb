# encoding: UTF-8
class ArExerciseForm < BaseForm
  attr_reader :ar_exercise, :questions_form

  attribute :title, String
  attribute :user_id, Integer
  attribute :questions, Hash,
    default: Hash[
      0.upto(2).collect { |i| [i, { title: '', statement: '', position: i }] }
    ]
  attribute :space_id, Integer

  validates :questions, length: { is: 3 }
  validates :user_id, :space_id, presence: true

  def valid?
    if questions_form.collect(&:valid?).reduce(:&)
      super
    else
      questions_form.each_with_index do |question, index|
        errors[:questions][index] = question.errors
      end
      false
    end
  end

  def persist!
    @ar_exercise = ArExercise.create(title: title) do |e|
      #FIXME this should be a computed property from ID
      last_id = ArExercise.last.try(:id) || 0
      e.title = "Exercício #{last_id + 1}"
      e.user = user
      e.space = space
    end

    @questions_form = questions_form.collect do |question|
      question.ar_exercise_id = @ar_exercise.id
      question.save
      question
    end

    @ar_exercise
  end

  def questions_form
    @questions_form ||= questions.collect do |key, value|
      QuestionForm.new(value)
    end
  end

  def user
    @user = User.find_by_id(user_id)
  end

  def space
    @space = Space.find_by_id(space_id)
  end
end
