class AnswersController < BaseController
  respond_to :html
  layout 'application'

  def create
    @question = Question.find(params[:question_id])
    @answer = AnswerForm.new(params[:answer_form])

    if @answer.save
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end
end
