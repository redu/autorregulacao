class QuestionsController < ApplicationController
  respond_to :html

  def show
    @question = Question.find(params[:id])
    @answer = AnswerForm.new(question_id: @question.id, user_id: current_user.id)

    respond_with(@question)
  end
end
