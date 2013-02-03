# Handles the logic of creating Subjects and Lectures with Redu REST API
class ArExerciseRemoteService
  include Rails.application.routes.url_helpers
  include Virtus

  attribute :ar_exercise, ArExercise
  attribute :client, Redu::Client, default: lambda { |service,attrs|
    Redu::Client.new(oauth_token_secret: service.ar_exercise.user.token)
  }

  # Creates both the Subject (ArExercise) and Lectures (Question) on Redu
  def create!
    exercise = create_subject!
    create_questions!

    exercise
  end

  # Creates the ArExercises as Subject on Redu.
  def create_subject!
    attrs = { name: ar_exercise.title }
    subject = client.
      create_subject(space_id: ar_exercise.space.core_id, subject: attrs)

    populate_exercise_with_response_data!(ar_exercise, subject)

    ar_exercise
  end

  # Creates the question as Lectures on Redu. It assumes ArExercise was created
  # and has the core_id.
  def create_questions!
    ar_exercise.questions.each do |question|
      attrs = build_lecture_params(question)

      response = client.connection.
        post("subjects/#{ar_exercise.core_id}/lectures", lecture: attrs)

      populate_question_with_response_data!(question, response)

      question
    end
  end

  private

  def build_lecture_params(question)
    {  name: question.title, type: 'Canvas', position: question.position,
       lectureable:
       { client_application_id: client_application_id,
         current_url: question_url(question)
    }
    }.with_indifferent_access
  end

  def populate_question_with_response_data!(question, response)
    if core_id = response.body["id"]
      question.core_id = core_id
      question.representation = response.body
      question.save
    end

    question
  end

  def populate_exercise_with_response_data!(ar_exercise, subject)
    if core_id = subject.id
      ar_exercise.core_id = core_id
      ar_exercise.representation = subject.to_hash
      ar_exercise.save
    end

    ar_exercise
  end


  def client_application_id
    Autoregulation::Application.config.client_id
  end

  def default_url_options
    { host: Autoregulation::Application.config.host }
  end
end
