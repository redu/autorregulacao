require 'spec_helper'

describe Question do
  context "relation" do
    it { should belong_to(:ar_exercise) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  it "should respond to #href_to" do
    subject.should respond_to :href_to
  end
end
