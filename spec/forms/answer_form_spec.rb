require 'spec_helper'

describe AnswerForm do
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
    it "should #persist! if valid" do
      subject.should_receive(:persist!)
      subject.save
    end

    it "should not receive persist if the answer is invalid" do
      subject.reflection = nil
      subject.should_not_receive(:persist!)
      subject.save
    end

    it "should return true when successful" do
      subject.save.should be
    end

    it "should return false when not successful" do
      subject.reflection = nil
      subject.save.should_not be
    end

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
