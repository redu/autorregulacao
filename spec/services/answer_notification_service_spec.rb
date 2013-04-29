require 'spec_helper'

describe AnswerNotificationService do
  let(:exercise) { FactoryGirl.build(:ar_exercise) }
  subject do
    AnswerNotificationService.
      new(question: FactoryGirl.build(:question), exercise: exercise)
  end

  context "#notify" do
    let(:users) do
      3.times.collect do
        user = FactoryGirl.build(:user)
        Redu::User.new(first_name: user.name, email: user.email)
      end
    end
    before do
      exercise.stub(:space).and_return(FactoryGirl.build(:space))
      exercise.stub(:user).and_return(FactoryGirl.build(:user))
      subject.stub_chain(:space_ws, :users).and_return(users)
    end

    it "should deliver notifications" do
      expect {
        subject.notify
      }.to change(ActionMailer::Base.deliveries, :count).by(3)
    end

    it "should fail silently" do
      mail = mock('Mail')
      mail.stub(:deliver).and_raise(Exception)
      AnswerMailer.stub(:new_answer).and_return(mail)

      expect { subject.notify }.to_not raise_error
    end
  end
end
