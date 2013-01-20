# encoding: UTF-8
require 'spec_helper'

describe ArExerciseForm do
  it_behaves_like "a form"
  let(:qs) do
    Hash[1.upto(3).collect { |i| [i, { title: 'lorem', statement: 'lorem' }] }]
  end

  subject do
    ArExerciseForm.new(title: 'Lorem', questions: qs, user_id: 1, space_id: 1)
  end

  context "validations" do
    %w(user_id space_id).each do |attr|
      it { should validate_presence_of attr }
    end

    it "should ensure length of questions (up to 2)" do
      0.upto(2).each do |i|
        subject.questions = Array.new(i, {})
        subject.should_not be_valid
      end
    end

    it "should ensure length of question (3)" do
      subject.should be_valid
    end

    context "#valid?" do
      before do
        subject.stub(:questions_form).
          and_return(3.times.collect { mock('QuestionForm') })
        subject.questions_form.each do |mock|
          mock.stub(:errors).and_return({})
        end
      end

      it "should validate questions" do
        subject.questions_form.each { |mock| mock.should_receive(:valid?) }
        subject.valid?
      end

      it "should return false if some question isn't valid" do
        subject.questions_form.each_with_index do |mock, i|
          mock.stub(:valid?).and_return(i%2 == 0)
        end
        subject.should_not be_valid
      end

      it "should display errors for questions" do
        subject.questions_form.each do |mock|
          mock.stub(:valid?).and_return(false)
          mock.stub(:errors).and_return({foo: :bar})
        end

        subject.valid?
        subject.errors[:questions].each do |q|
          q.should include({ foo: :bar })
        end
      end
    end
  end

  context "#persist!" do
    let(:user) { FactoryGirl.create(:user) }
    let(:space) { FactoryGirl.create(:space) }
    before do
      subject.user_id = user.id
      subject.space_id = space.id
    end

    it "should save the questions" do
      expect {
        subject.persist!
      }.to change(Question, :count).by(3)
    end

    it "should associate the ArExercise to the Space" do
      expect {
        subject.persist!
      }.to change(subject.space.ar_exercises, :count).by(1)
    end

    it "should save the exercise" do
      expect {
        subject.persist!
      }.to change(ArExercise, :count).by(1)
    end
    it "should associate the user to the exercise" do
      subject.persist!
      subject.ar_exercise.user.should == user
    end
  end

end
