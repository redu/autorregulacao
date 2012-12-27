require 'spec_helper'

describe Cooperation do
  context "relations" do
    it { should belong_to(:answer) }
    it { should belong_to(:user) }
  end
end
