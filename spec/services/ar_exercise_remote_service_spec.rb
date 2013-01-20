require 'spec_helper'

describe ArExerciseRemoteService do
  include Rails.application.routes.url_helpers

  context ".new" do
    let(:ar_exercise) { FactoryGirl.create(:ar_exercise) }
    it "should be initilized with ArExercise" do
      exercise = FactoryGirl.build(:ar_exercise)
      ArExerciseRemoteService.new(ar_exercise: exercise).should
        ArExerciseRemoteService
    end

    it "should define a defualt client" do
      exercise = mock_model('ArExercise')
      user = FactoryGirl.create(:user)
      exercise.stub(:user).and_return user
      subject = ArExerciseRemoteService.new(ar_exercise: exercise)
      subject.client.oauth_token_secret.should == user.token
    end
  end

  context "#create_subject!" do
    let(:user) { FactoryGirl.create(:user) }
    let(:client) {  Redu::Client.new(oauth_token_secret: user.token) }
    let(:space) { FactoryGirl.create(:space) }
    let(:exercise) do
      FactoryGirl.create(:ar_exercise, user: user, space: space)
    end
    subject do
      ArExerciseRemoteService.new(ar_exercise: exercise)
    end
    before do
      subject.client.stub(:create_subject).
        with(space_id: space.core_id, subject: { name: exercise.title }).
        and_return(Redu::Subject.new(id: 12, name: exercise.title))
    end

    it "should create the ArExercise as a Redu::Subject" do
      subject.client.should_receive(:create_subject).
        with(space_id: space.core_id, subject: { name: exercise.title })

      subject.create_subject!
    end

    it "should return a updated instance of ArExercise" do
      subject.create_subject!.core_id.should == 12
    end
  end

  context "#create_questions!" do
    let(:user) { FactoryGirl.create(:user) }
    let(:client) {  Redu::Client.new(oauth_token_secret: user.token) }
    let(:exercise) do
      FactoryGirl.create(:complete_ar_exercise, user: user, core_id: 12)
    end
    subject do
      ArExerciseRemoteService.new(ar_exercise: exercise)
    end
    def build_response_mock(hash)
      r = mock 'Faraday::Response'
      r.stub(:body).and_return(hash)
      r
    end
    before do
      Autoregulation::Application.config.stub(:client_id).and_return(12)
    end

    it "should create the Question as Redu::Lecture" do
      exercise.questions.each do |q|
        attrs = { name: q.title, type: 'Canvas',
                  lectureable: { client_application_id: 12,
                                 current_url: question_url(q) } }

        subject.client.connection.should_receive(:post).
          with("subjects/#{exercise.core_id}/lectures", lecture: attrs).
        and_return(build_response_mock(attrs))
      end
      subject.create_questions!
    end

    it "should update Question#core_id" do
      response = build_response_mock({ id: 3 })
      subject.client.connection.stub(:post).and_return(response)

      subject.create_questions!
      subject.ar_exercise.questions.map(&:core_id).should == [3,3,3]
    end
  end

  context "#create!" do
    before do
      subject.stub(:create_subject!)
      subject.stub(:create_questions!)
    end

    it "should invoke #create_subject!" do
      subject.should_receive(:create_subject!)
      subject.create!
    end

    it "should invoke #create_questions!" do
      subject.should_receive(:create_questions!)
      subject.create!
    end
  end

  def default_url_options
    { host: Autoregulation::Application.config.host }
  end
end
