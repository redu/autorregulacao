class AnswerMailer < ActionMailer::Base
  layout 'mail'
  default from: "no-reply@autorregulacao.herokuapp.com"

  # Options:
  #   answer => answer the user create
  #   ar_exercise => exercise where the answer was created
  #   user => user who is going to receive the e-mail
  def new_answer(opts={})
    @question = opts[:question]
    @user = opts[:user]
    @ar_exercise = opts[:ar_exercise]
    @space = @ar_exercise.space

    mail(to: @user.email, subject: "Ajude o seu colega na disciplina #{@space.name}")
  end
end
