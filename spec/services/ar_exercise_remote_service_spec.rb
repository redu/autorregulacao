require 'spec_helper'

describe ArExerciseRemoteService do
  include Rails.application.routes.url_helpers
  let(:user) { FactoryGirl.create(:user) }
  let(:client) {  Redu::Client.new(oauth_token_secret: user.token) }

  context do
    let(:exercise) do
      mock_model('ArExercise') do |m|
        m.stub(:user).and_return(mock_model('User'))
      end
    end
    subject { ArExerciseRemoteService.new(resource: exercise) }
    it_should_behave_like "a remote service"
  end

  context "#create_subject!" do
    let(:space) { FactoryGirl.create(:space) }
    let(:exercise) do
      FactoryGirl.create(:ar_exercise, user: user, space: space)
    end
    subject do
      ArExerciseRemoteService.new(resource: exercise)
    end
    let(:core_subject) do
      Redu::Subject.new(id: 12, name: exercise.title)
    end
    before do
      subject.client.stub(:create_subject).
        with(space_id: space.core_id, subject: { name: exercise.title }).
        and_return(core_subject)
    end

    it "should create the ArExercise as a Redu::Subject" do
      subject.client.should_receive(:create_subject).
        with(space_id: space.core_id, subject: { name: exercise.title })

      subject.create_subject!
    end

    it "should return a updated instance of ArExercise" do
      subject.create_subject!.core_id.should == 12
    end

    it "should update ArExercise#representation" do
      subject.create_subject!.representation.should == core_subject.to_hash
    end
  end

  context "#create_questions!" do
    let(:exercise) do
      FactoryGirl.create(:complete_ar_exercise, user: user, core_id: 12)
    end
    subject do
      ArExerciseRemoteService.new(resource: exercise)
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
        attrs = { "name" => q.title, "type" => 'Canvas', "position" => q.position,
                  "lectureable" => { "client_application_id" => 12,
                                 "current_url" => question_url(q) } }.with_indifferent_access

        subject.client.connection.should_receive(:post).
          with("subjects/#{exercise.core_id}/lectures", lecture: attrs).
        and_return(build_response_mock(attrs))
      end
      subject.create_questions!
    end

    it "should update Question#core_id" do
      response = build_response_mock({ "id" => 3 })
      subject.client.connection.stub(:post).and_return(response)

      subject.create_questions!
      subject.resource.questions.map(&:core_id).should == [3,3,3]
    end

    it "should update Question#representation" do
      repr = { "id" => 3, "foo" => :bar }
      response = build_response_mock(repr)
      subject.client.connection.stub(:post).and_return(response)

      subject.create_questions!
      subject.resource.questions.map(&:representation).
        should == 3.times.collect { repr }
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
