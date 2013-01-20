class ArExercisesController < ApplicationController
  layout 'space'
  respond_to :html

  def new
    @exercise_form = ArExerciseForm.
      new(user_id: current_user.id, space_id: space.id)
    @exercise_form.questions_form

    respond_with(@exercise_form)
  end

  def create
    @exercise_form = ArExerciseForm.new(params[:ar_exercise_form])

    if @exercise_form.save
      remote_service = ArExerciseRemoteService.new(ar_exercise: @exercise_form.ar_exercise)
      remote_service.create!
      redirect_to question_path(@exercise_form.ar_exercise.questions.first)
    else
      render :new
    end
  end

  def index
    @exercises = ArExercise.includes(questions: :answers).all

    respond_with(@exercises)
  end

  private

  def space
    raise ActiveRecord::RecordNotFound.new("There is no space with space_id == #{params[:redu_space_id]}") unless params[:redu_space_id]

    @space_finder ||= SpaceFinderService.
      new(space_id: params[:redu_space_id], user: current_user)

    @space_finder.find
  end
end
