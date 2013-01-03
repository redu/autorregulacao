class QuestionsController < ApplicationController
  respond_to :html

  def show
    question = Question.find(params[:id])
    @question_service = QuestionService.new(user: current_user, question: question)

    if @question_service.answered?
      answer = @question_service.answer
      @answer_service = AnswerService.new(user: current_user, answer: answer)
      @cooperation_form = CooperationForm.new(user_id: current_user.id, answer_id: answer.id)
      render 'answers/show'
    else
      @answer_form = @question_service.answer_form
      respond_with(@question_service)
    end
  end
end
