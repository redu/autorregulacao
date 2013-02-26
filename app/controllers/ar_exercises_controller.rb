class ArExercisesController < ApplicationController
  layout 'space'
  respond_to :html

  def new
    @space = Space.find_by_id(params[:space_id]) || space
    @exercise_form = ArExerciseForm.
      new(user_id: current_user.id, space_id: @space.id)
    @exercise_form.questions_form

    respond_with(@exercise_form)
  end

  def create
    @space = Space.find(params[:space_id])
    @exercise_form = ArExerciseForm.new(params[:ar_exercise_form])

    if @exercise_form.save
      ws = ArExerciseRemoteService.new(resource: @exercise_form.ar_exercise)
      ws.create! do |exercise|
        space_ws = SpaceRemoteService.
          new(resource: exercise.space, user: exercise.user)
        space_ws.users.
          each { |u| ArExerciseMailer.new_exercise(exercise, u).deliver }
      end
      redirect_to space_ar_exercises_path(@space)
    else
      render :new
    end
  end

  def email
    @space = Space.find(params[:space_id])
    @exercise = ArExercise.find(params[:id])

    ArExerciseMailer.summary(@exercise, current_user).deliver

    redirect_to space_ar_exercises_path(@space)
  end

  def index
    @space = Space.find(params[:space_id])
    @exercises = @space.ar_exercises.includes(questions: :answers)

    respond_with(@exercises)
  end

  private

  def space
    unless params[:redu_space_id]
      error = ActiveRecord::RecordNotFound.
        new("There is no space with space_id == #{params[:redu_space_id]}")
      raise error and return
    end

    @space_finder ||= SpaceFinderService.
      new(space_id: params[:redu_space_id], user: current_user)

    @space_finder.find
  end
end
