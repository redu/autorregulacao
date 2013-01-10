class QuestionsController < ApplicationController
  respond_to :html

  def show
    question = Question.find(params[:id])
    @question_service = QuestionService.new(user: current_user, question: question)

    if @question_service.answered?
      answer = question.answers.first(conditions: { user_id: current_user.id })
      @answer_service = AnswerService.new(user: current_user, answer: answer)
      @cooperation_form = CooperationForm.new(user_id: current_user.id, answer_id: answer.id)
      render 'answers/show'
    else
      @answer_form = @question_service.answer_form
      respond_with(@question_service)
    end
  end

  def summary
    question = Question.find(params[:id], include: { answers: :cooperations })
    @question_service = QuestionService.new(user: current_user, question: question)

    respond_with(@question_service) do |format|
      format.html { render layout: 'space' }
    end
  end
end
