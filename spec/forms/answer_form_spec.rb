require 'spec_helper'

describe AnswerForm do
  it_behaves_like "a form"
  let(:question) { Question.create }
  let(:user) { User.create }
  subject do
    AnswerForm.new(question_id: question.id, user_id: user.id,
                   initial: 'Abc', rationale: 'Abc', reflection: 'Abc')
  end

  it "should be initialized with question_id, user_id and answer attrs" do
    subject.should be_a AnswerForm
  end

  it "should not be #persisted?" do
    subject.persisted?.should_not be
  end

  context "#save" do
    it "should associate the answer to the user" do
      subject.save
      subject.answer.user.should == user
    end
  end

  context "validations" do
    %w(user_id question_id initial rationale reflection).each do |attr|
      it { should validate_presence_of attr }
    end
  end
end
