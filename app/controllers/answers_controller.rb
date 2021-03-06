class AnswersController < ApplicationController
  respond_to :html

  def create
    question = Question.find(params[:question_id])
    answer_form = AnswerForm.new(params[:answer_form])

    if answer_form.save
      notification = AnswerNotificationService.
        new(exercise: question.ar_exercise, question: question)
      notification.notify

      redirect_to question_path(question)
    else
      @question_service = QuestionService.
        new(user: current_user, question: question, answer_form: answer_form)
      render 'questions/show'
    end
  end

  def index
    question = Question.find(params[:question_id])
    @question_service = PeerAnsweringService.
      new(user: current_user, question: question)

    respond_with(@question_service)
  end

  def show
    answer = Answer.find(params[:id])
    @answer_service = AnswerService.new(user: current_user, answer: answer)
    @cooperation_form = CooperationForm.new(user_id: current_user.id, answer_id: answer.id)

    @cooperation = answer.cooperations.
      find(:first, conditions: { user_id: current_user })
    if @cooperation
      @cooperation_service = \
        CooperationService.new(user: current_user, cooperation: @cooperation)
      @feedback_form = \
        FeedbackForm.new(user_id: current_user, cooperation_id: @cooperation)
    end
  end
end
