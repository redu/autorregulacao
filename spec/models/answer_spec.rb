require 'spec_helper'

describe Answer do
  context "relations" do
    it { should have_many(:cooperations).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should belong_to(:question) }
  end
end
