require 'spec_helper'

describe QuestionService do
  it "should be initialized by a User and Question" do
    QuestionService.new(question: Question.new, user: User.new).should
      be_a QuestionService
  end

  context "#answer_form" do
    let(:user) do
      u = mock_model('User')
      u.stub(:id).and_return(12)
      u
    end
    let(:question) do
      q = mock_model('Question')
      q.stub(:id).and_return(12)
      q
    end
    subject do
      QuestionService.new(question: question, user: user)
    end

    it "should return a AnswerForm" do
      subject.answer_form.should be_a AnswerForm
    end

    it "should bound the form to the User" do
      subject.answer_form.user_id.should == user.id
    end

    it "should bound the form to the Question" do
      subject.answer_form.question_id.should == question.id
    end

    it "should return the AnswerForm passed to #new" do
      answer_form = AnswerForm.new
      subject = QuestionService.new(question: question, user: user,
                                    answer_form: answer_form)
      subject.answer_form.should == answer_form
    end
  end

  context "#answered?" do
    let(:user) { User.create }
    let(:question) { Question.create }
    subject do
      QuestionService.new(question: question, user: user)
    end

    it "shuold return true when the User answered" do
      question.answers.create do |q|
        q.user = user
      end

      subject.answered?.should be
    end

    it "should return false when the User didn't answer" do
      subject.answered?.should_not be
    end
  end

  context "#answer_services" do
    let(:user) { FactoryGirl.create(:user) }
    let(:question) { FactoryGirl.create(:question) }
    subject do
      QuestionService.new(question: question, user: user)
    end

    it "should yield an answer service instance" do
      FactoryGirl.create(:complete_answer, cooperations_count: 0,
                         question: question)

      expect { |block|
        subject.answer_services(&block)
      }.to yield_with_args(AnswerService)
    end

    it "should not yield if there is no answers" do
      expect { |block|
        subject.answer_services(&block)
      }.to_not yield_control
    end

    it "should accept conditions" do
      conditions = ["user_id != ?", user.id]
      question.answers.stub(:where).and_return([])
      question.answers.should_receive(:where).with(conditions)
      subject.answer_services(where: conditions)
    end

    it "should return a collection of AnswerService if there isn't a block" do
      FactoryGirl.create(:complete_answer, cooperations_count: 0, question: question)
      answer = AnswerService.new(answer: question.answers.first, user: user)
      subject.answer_services.size.should == 1
      subject.answer_services.first.should be_a AnswerService
    end
  end
end
