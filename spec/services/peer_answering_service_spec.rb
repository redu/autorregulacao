require 'spec_helper'

describe PeerAnsweringService do

  it "should be initialized with a Answer and a User" do
    question = mock_model('Question')
    user = mock_model('User')

    PeerAnsweringService.new(question: question, user: user).should \
      be_a PeerAnsweringService
  end

  context "#pending" do
    let(:user) { FactoryGirl.create(:user) }
    let(:initiators) { FactoryGirl.create_list(:user, 3) }
    let(:exercise) do
      FactoryGirl.create(:complete_ar_exercise, questions_count: 0)
    end
    let(:questions) do
      FactoryGirl.create_list(:complete_question, 3, ar_exercise: exercise,
                              answers_count: 0)
    end
    let(:current_question) { questions.first }
    let(:other_question) { questions.last }

    subject do
      PeerAnsweringService.new(question: current_question, user: user)
    end

    context "when the user was the first cooperator to all initiators" do
      it "should return pending answers" do
        answers = questions.product(initiators).collect do |question, initiator|
          question.answers << \
            FactoryGirl.create(:complete_answer, question: question,
                               cooperations_count: 0, user: initiator)
        end.flatten
        cooperations = other_question.answers.collect do |a|
          a.cooperations << \
            FactoryGirl.create(:cooperation, user: user, answer: a)
        end

        subject.pending.to_set.should ==
          answers.select { |a| a.question == current_question }.to_set
      end
    end

    context "when the user was first cooperator to one initiator but not for others" do
      it "should return pending answers" do
        answers = questions.product(initiators).collect do |question, initiator|
          question.answers << \
            FactoryGirl.create(:complete_answer, question: question,
                               cooperations_count: 0, user: initiator)
        end.flatten

        a = other_question.answers.first
        a.cooperations << FactoryGirl.create(:cooperation, user: user, answer: a)

        subject.pending.to_set.should ==
          current_question.answers.where(user_id: a.user_id).to_set
      end
    end

    context "when the user wasn't the first cooperator" do
      it "should return pending answers" do
        answers = questions.product(initiators).collect do |question, initiator|
          question.answers << \
            FactoryGirl.create(:complete_answer, question: question,
                               cooperations_count: 0, user: initiator)
        end.flatten
        cooperations = other_question.answers.collect do |a|
          a.cooperations << \
            FactoryGirl.create(:cooperation,
                               user: FactoryGirl.create(:user), answer: a)
          a.cooperations << FactoryGirl.create(:cooperation, user: user, answer: a)
        end

        subject.pending.should be_empty
      end
    end
  end
end
