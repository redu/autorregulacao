require 'spec_helper'

describe AnswerService do
  context "#new" do
    it "should accept an user and answer" do
      AnswerService.new(answer: mock_model('Answer'), user: mock_model('User')).
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

  context "#cooperated? with answer.user != nil" do
    let(:answer) { FactoryGirl.create(:complete_answer) }
    let(:user) { FactoryGirl.create(:user) }
    subject do
      AnswerService.new(answer: answer, user: user)
    end

    it "should return true if the user cooperated" do
      answer.cooperations.first.update_attribute(:user_id, user.id)
      subject.cooperated?.should be
    end

    it "should return false if the user didn't cooperate" do
      subject.cooperated?.should_not be
    end
  end

  context "#initiator?" do
    let(:answer) { FactoryGirl.build(:answer) }
    let(:user) { FactoryGirl.create(:user) }
    subject do
      AnswerService.new(answer: answer, user: user)
    end
    it "should return true if #user is the answer owner" do
      answer.user = user
      subject.initiator?.should be
    end

    it "should return false if #user isn't answer owner" do
      subject.initiator?.should_not be
    end
  end

  context "#cooperated? with answer.user == nil" do
    let(:answer) { FactoryGirl.create(:complete_answer) }
    let(:user) { nil }
    subject do
      AnswerService.new(answer: answer, user: user)
    end

    it "should return false if someone cooperate" do
      subject.cooperated?.should_not be
    end

    it "should return false if anyone cooperate" do
      answer_with_no_cooperations = \
        FactoryGirl.create(:complete_answer, cooperations_count: 0)
      subject = AnswerService.
        new(answer: answer_with_no_cooperations, user: user)

      subject.cooperated?.should_not be
    end
  end

  context "#question_service" do
    let(:answer) { mock_model 'Answer' }
    let(:user) { mock_model 'User' }
    let(:question_double) { mock_model 'Question' }
    subject do
      AnswerService.new(answer: answer, user: user)
    end
    before do
      answer.stub(:question).and_return(question_double)
    end

    it "returns a instance of question service" do
      subject.question_service.should be_a QuestionService
    end

    it "should be bounded to #answer.question" do
      subject.question_service.question.should == question_double
    end

    it "should be bounded to #user" do
      subject.question_service.user.should == user
    end
  end
end
