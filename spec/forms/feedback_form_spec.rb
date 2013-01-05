require 'spec_helper'

describe FeedbackForm do
  it_behaves_like 'a form'
  context "validations" do
    %w(feedback_statement feedback_reflection user_id id).each do |attr|
      it { should validate_presence_of attr }
    end

    # it { should ensure_inclusion_of(:feedback_accepted).in_range([true, false]) }
  end

  context "#persist!" do
    let(:params) do
      { feedback_statement: 'statement', feedback_reflection: 'reflection',
        feedback_accepted: true, user_id: user.id }
    end
    let(:user) { mock_model('User') }
    let(:cooperation) { FactoryGirl.create(:complete_cooperation) }
    subject do
      FeedbackForm.new(params.merge({user_id: user.id, id: cooperation.id}))
    end
    before do
      Cooperation.stub(:find_by_id).and_return(cooperation)
    end

    it "should update cooperation" do
      expect {
        subject.attributes = params.except(:user_id).
          merge({feedback_accepted: false})
        subject.save
      }.to change(subject.cooperation, :feedback_accepted)
    end

    it "should invoke #update_attributes" do
      cooperation.should_receive(:update_attributes).
        with(params.except(:user_id))
      subject.save
    end
  end
end
