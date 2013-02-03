require 'spec_helper'

describe RemoteService do
  context ".new" do
    let(:ar_exercise) { FactoryGirl.create(:ar_exercise) }
    it "should be initilized with a Resource" do
      resource = FactoryGirl.build(:ar_exercise)
      RemoteService.new(resource: resource).should
        RemoteService
    end

    it "should define a defualt client" do
      resource = mock_model('ArExercise')
      user = FactoryGirl.create(:user)
      resource.stub(:user).and_return user
      subject = RemoteService.new(resource: resource)
      subject.client.oauth_token_secret.should == user.token
    end
  end
end
