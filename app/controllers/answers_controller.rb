class AnswersController < BaseController
  respond_to :html
  layout 'application'

  def create
    question = Question.find(params[:question_id])
    answer_form = AnswerForm.new(params[:answer_form])

    if answer_form.save
      redirect_to question_path(question)
    else
      @question_service = QuestionService.
        new(user: current_user, question: question, answer_form: answer_form)
      render 'questions/show'
    end
  end

  def index
    question = Question.find(params[:question_id])
    @question_service = QuestionService.new(user: current_user, question: question)

    respond_with(@question_service)
  end

  def show
    answer = Answer.find(params[:id])
    question = answer.question
    @question_service = QuestionService.new(user: current_user, question: question)
    @answer_service = AnswerService.new(user: current_user, answer: answer)
    @cooperation_form = CooperationForm.new(user_id: current_user.id, answer_id: answer.id)
  end
end
