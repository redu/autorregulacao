# encoding: UTF-8

class ArExerciseMailer < ActionMailer::Base
  layout 'mail'
  default from: "no-reply@autorregulacao.herokuapp.com"

  def new_exercise(ar_exercise, user)
    @user = user
    @ar_exercise = ar_exercise
    @space = ar_exercise.space

    mail(to: user.email, subject: "Nova atividade criada em #{@space.name}")
  end

  def summary(ar_exercise, user)
    @user = user
    @ar_exercise = ar_exercise
    @pdf_url = space_ar_exercise_questions_url(@ar_exercise.space,
                                               @ar_exercise, format: 'pdf')

    mail(to: @user.email,
         subject: "Sumário de atividades para o Exercício ##{@ar_exercise.id}")
  end
end
