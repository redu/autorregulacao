class ArExercisesController < ApplicationController
  layout 'space'
  respond_to :html

  def new
    @exercise_form = ArExerciseForm.new(user_id: current_user.id)
    @exercise_form.questions_form

    respond_with(@exercise_form)
  end

  def create
    @exercise_form = ArExerciseForm.new(params[:ar_exercise_form])

    if @exercise_form.save
      redirect_to question_path(@exercise_form.ar_exercise.questions.first)
    else
      render :new
    end
  end
end
