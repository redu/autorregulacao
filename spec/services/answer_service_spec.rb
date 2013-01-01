require 'spec_helper'

describe AnswerService do
  context "#new" do
    it "should accept an user and answer" do
      AnswerService.new(answer: mock_model('Question'), user: mock_model('User')).
        should be_a AnswerService
    end

    it "should respond to #user" do
      user = mock_model 'User'
      AnswerService.new(user: user).user.should == user
    end
    it "should respond to #answer" do
      answer = mock_model 'Answer'
      AnswerService.new(answer: answer).answer.should == answer
    end
  end

  context "#open? with answer.user != nil" do
    let(:answer) { FactoryGirl.create(:complete_answer) }
    let(:user) { FactoryGirl.create(:user) }
    subject do
      AnswerService.new(answer: answer, user: user)
    end

    it "should return false if the user answered" do
      answer.cooperations.first.update_attribute(:user_id, user.id)
      subject.open?.should_not be
    end

    it "should return true if the user didn't answer" do
      subject.open?.should be
    end
  end

  context "#open? with answer.user == nil" do
    let(:answer) { FactoryGirl.create(:complete_answer) }
    let(:user) { nil }
    subject do
      AnswerService.new(answer: answer, user: user)
    end

    it "should return false if someone answered" do
      subject.open?.should_not be
    end

    it "should return true if anyone answered" do
      answer_with_no_cooperations = \
        FactoryGirl.create(:complete_answer, cooperations_count: 0)
      subject = AnswerService.
        new(answer: answer_with_no_cooperations, user: user)

      subject.open?.should be
    end
  end
end
