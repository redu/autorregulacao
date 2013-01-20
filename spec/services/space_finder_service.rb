require 'spec_helper'

describe SpaceFinderService do
  context ".new" do
    subject { SpaceFinderService.new(space_id: 12, user: FactoryGirl.build(:user)) }
    it "should be initialized with space_id and user" do
      subject.should be_a SpaceFinderService
    end

    it "should define a default client" do
      subject.client.should be_a Redu::Client
    end

    it "should accept an optional Client" do
      client = Redu::Client.new(oauth_token_secret: 123)
      opts =  { space_id: 12, user: FactoryGirl.build(:user), client: client }
      subject = SpaceFinderService.new(opts)
      subject.client.should == client
    end
  end

  context "#find" do
    let(:api_space) { Redu::Space.new(id: 12, name: 'Lorem') }
    let(:user) { FactoryGirl.build(:user) }
    subject { SpaceFinderService.new(space_id: 12, user: user) }
    before do
      subject.client.stub(:space).with(12).and_return(api_space)
    end

    context "when the Space doesn't exist" do
      it "should fetch from Redu" do
        subject.client.should_receive(:space).with(12)
        subject.find
      end

      it "should return instance of Space" do
        subject.find.should be_a Space
      end

      it "should return a persisted instance of Space" do
        subject.find.should be_persisted
      end

      it "should raise ActiveRecord::RecordNotFound when there isnt Space" do
        subject.client.stub(:space).with(12).and_return(nil)
        expect {
          subject.find
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when the Space already exists" do
      let(:space) { FactoryGirl.create(:space) }
      subject { SpaceFinderService.new(space_id: space.core_id, user: user) }

      it "should not fetch from Redu" do
        subject.client.should_not_receive(:space)
        subject.find
      end

      it "should find by core_id" do
        Space.should_receive(:find_or_initialize_by_core_id).and_return(space)
        subject.find
      end

      it "should return instance of Space" do
        subject.find.should be_a Space
      end

      it "should return a persisted instance of Space" do
        subject.find.should be_persisted
      end
    end
  end


end
