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

  context "#answer" do
    let(:user) do
      u = mock_model('User')
      u.stub(:id).and_return(12)
      u
    end
    let(:question) { Question.create }
    subject do
      QuestionService.new(question: question, user: user)
    end
    it "should return the answer" do
      answer = question.answers.create do |q|
        q.user_id = 12
      end

      subject.answer.should == answer
    end

    it "should return nil when there is no answer" do
      subject.answer.should be_nil
    end
  end
end
