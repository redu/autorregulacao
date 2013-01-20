# Handles the logic of creating Subjects and Lectures with Redu REST API
class ArExerciseRemoteService
  include Rails.application.routes.url_helpers
  include Virtus

  attribute :ar_exercise, ArExercise
  attribute :client, Redu::Client, default: lambda { |service,attrs|
    Redu::Client.new(oauth_token_secret: service.ar_exercise.user.token)
  }

  def create!
    exercise = create_subject!

    exercise.questions.each do |question|
      create_question!(question)
    end

    exercise
  end

  def create_subject!
    attrs = { name: ar_exercise.title }
    subject = client.
      create_subject(space_id: ar_exercise.space.core_id, subject: attrs)

    if core_id = subject.id
      ar_exercise.core_id = core_id
      ar_exercise.save
    end

    ar_exercise
  end

  # Creates the question as Lectures on Redu. It assumes ArExercise was created
  # and has the core_id.
  def create_questions!
    ar_exercise.questions.map do |question|
      attrs = {  name: question.title, type: 'Canvas',
                 lectureable:
                 { client_application_id: client_application_id,
                   current_url: question_url(question)
                 }
      }

      response = client.connection.
        post("subjects/#{ar_exercise.core_id}/lectures", lecture: attrs)

      if core_id = response.body[:id]
        question.core_id = core_id
        question.save
      end

      question
    end
  end

  private

  def client_application_id
    Autoregulation::Application.config.client_id
  end

  def default_url_options
    { host: Autoregulation::Application.config.host }
  end
end
