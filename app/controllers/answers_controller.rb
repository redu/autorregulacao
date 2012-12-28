class AnswersController < BaseController
  respond_to :html
  layout 'application'

  def create
    question = Question.find(params[:question_id])
    @answer = AnswerForm.new(params[:answer_form])

    if @answer.save
      redirect_to question_path(question)
    else
      render :new
    end
  end

  def new
    question = Question.find(params[:question_id])

    # question.answers.exists?(:user_id => current_user)
    @answer = AnswerForm.new(question_id: question.id, user_id: current_user.id)

    respond_with(@answer)
  end
end
