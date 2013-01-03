require 'spec_helper'

describe CooperationService do
  context "#new" do
    it "accepts a user and a cooperation" do
      CooperationService.new(user: User.new, cooperation: Cooperation.new).
        should be_a CooperationService
    end
  end
end
