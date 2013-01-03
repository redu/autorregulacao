class CooperationsController < BaseController
  layout 'application'
  def create
    answer = Answer.find(params[:answer_id])
    @answer_service = AnswerService.new(user: current_user, answer: answer)
    @question_service = QuestionService.new(user: current_user, question: answer.question)
    @cooperation_form = CooperationForm.new(params[:cooperation_form])

    if @cooperation_form.save
      redirect_to answer_path(answer)
    else
      render 'answers/show'
    end
  end
end
