class ArExerciseMailer < ActionMailer::Base
  layout 'mail'
  default from: "no-reply@autorregulacao.herokuapp.com"

  def new_exercise(ar_exercise, user)
    @user = user
    @ar_exercise = ar_exercise
    @space = ar_exercise.space

    mail(to: user.email, subject: "Nova atividade criada em #{@space.name}")
  end
end
