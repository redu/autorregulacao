require 'spec_helper'

describe ArExercise do
  context "relations" do
    it { should belong_to(:space) }
    it { should belong_to(:user) }
    it { should have_many(:questions).dependent(:destroy) }
  end
end
