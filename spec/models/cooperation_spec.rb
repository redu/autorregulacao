require 'spec_helper'

describe Cooperation do
  context "relations" do
    it { should belong_to(:answer) }
    it { should belong_to(:user) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:answer_id) }
  end
end
