class ArExerciseController < ApplicationController
  respond_to :html

  def new
    respond_with do |f|
      f.html { render layout: 'space'}
    end
  end

  def index
    respond_with do |f|
      f.html { render layout: 'space'}
    end
  end

  def show
    respond_with do |f|
      f.html { render layout: 'space'}
    end
  end

  def answer; end
  def cooperation_index; end
  def cooperate; end
end
