require 'spec_helper'

describe Answer do
  context "relations" do
    it { should have_many(:cooperations).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should belong_to(:question) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
  end
end
