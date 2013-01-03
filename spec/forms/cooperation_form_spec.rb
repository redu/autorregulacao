# encoding: UTF-8
require 'spec_helper'

describe CooperationForm do
  it_behaves_like "a form"

  context "validations" do
    %w(user_id answer_id rationale recommendation).each do |attr|
      it { should validate_presence_of attr }
    end

    it "should validate if the user already cooperated" do
      answer = FactoryGirl.create(:complete_answer)
      coop = answer.cooperations.first.user
      params = { answer_id: answer.id, user_id: coop.id,
                 rationale: 'Lorem', recommendation: 'Lorem' }
      subject = CooperationForm.new(params)
      subject.valid?
      subject.errors[:base].should include "Você já cooperou"
    end
  end

  context "#save" do
    let(:user) { FactoryGirl.create(:user) }
    let(:answer) { FactoryGirl.create(:complete_answer) }
    subject do
      CooperationForm.new(user_id: user.id, answer_id: answer.id, rationale: 'Lorem rational', recommendation: 'Lorem recommendation')
    end

    it "should create a new cooperation for the user" do
      subject.save
      answer.cooperations.where(user_id: user).should_not be_empty
    end
  end
end
