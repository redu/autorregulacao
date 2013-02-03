require 'spec_helper'

describe SpaceRemoteService do
  it_should_behave_like "a remote service" do
    subject do
      SpaceRemoteService.
        new(resource: mock_model('Space'), user: mock_model('User'))
    end
  end

  context "#users" do
    let(:space) { FactoryGirl.build(:space) }
    let(:user) { FactoryGirl.build(:user) }
    subject do
      SpaceRemoteService.new(resource: space, user: user)
    end

    it "should invoke Redu::Client#users" do
      subject.client.should_receive(:users).with(space_id: space.core_id)
      subject.users
    end

    it "should return a collection os Redu::User" do
      users = 3.times.map { { "id" => 12 } }
      subject.client.connection.stub(:get).and_return(build_response_mock(users))
      subject.users.each { |u| u.should be_a Redu::User }
    end
  end
end
