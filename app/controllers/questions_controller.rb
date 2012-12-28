class QuestionsController < ApplicationController
  respond_to :html

  def show
    question = Question.find(params[:id])
    @question_service = QuestionService.new(user: current_user, question: question)
    @answer_form = @question_service.answer_form

    respond_with(@question_service)
  end
end
