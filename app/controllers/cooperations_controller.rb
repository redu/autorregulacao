class CooperationsController < ApplicationController
  respond_to :html

  def create
    answer = Answer.find(params[:answer_id])
    @answer_service = AnswerService.new(user: current_user, answer: answer)
    @cooperation_form = CooperationForm.new(params[:cooperation_form])

    if @cooperation_form.save
      redirect_to answer_path(answer)
    else
      render 'answers/show'
    end
  end

  def update
    cooperation = Cooperation.find(params[:id])
    cooperation_service = CooperationService.new(user: current_user, cooperation: cooperation)
    @feedback_form = cooperation_service.feedback_form
    @feedback_form.attributes = params[:feedback_form]

    if @feedback_form.save
      redirect_to answer_path(cooperation.answer)
    else
      @answer_service = AnswerService.new(user: current_user, answer: cooperation.answer)
      render 'answers/show'
    end
  end
end
