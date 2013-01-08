require 'spec_helper'

describe QuestionForm do
  it_behaves_like "a form"

  context "validations" do
    %w(title statement).each do |attr|
      it { should validate_presence_of attr }
    end
  end

  context "#persist!" do
    let(:exercise) { FactoryGirl.create(:ar_exercise) }
    subject do
      QuestionForm.
        new(title: 'Lorem', text: 'Lorem', ar_exercise_id: exercise.id)
    end

    it "should create a new question" do
      expect { subject.persist! }.to change(Question, :count).by(1)
    end
  end

  context "#ar_exercise" do
    it "should return a instance of ArExercise" do
      exercise = mock_model 'ArExercise'
      ArExercise.stub(:find_by_id).and_return(exercise)

      QuestionForm.new(ar_exercise_id: exercise.id).ar_exercise.
        should == exercise
    end
  end
end
