# Handles the logic of creating Subjects and Lectures with Redu REST API
class ArExerciseRemoteService < RemoteService
  attribute :resource, ArExercise

  # Creates both the Subject (ArExercise) and Lectures (Question) on Redu
  def create!(&block)
    exercise = create_subject!
    create_questions!

    yield(exercise) if block_given?

    exercise
  end

  # Creates the ArExercises as Subject on Redu.
  def create_subject!
    attrs = { name: resource.title }
    subject = client.
      create_subject(space_id: resource.space.core_id, subject: attrs)

    populate_exercise_with_response_data!(resource, subject)

    resource
  end

  # Creates the question as Lectures on Redu. It assumes ArExercise was created
  # and has the core_id.
  def create_questions!
    resource.questions.each do |question|
      attrs = build_lecture_params(question)

      response = client.connection.
        post("subjects/#{resource.core_id}/lectures", lecture: attrs)

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

  def populate_exercise_with_response_data!(resource, subject)
    if core_id = subject.id
      resource.core_id = core_id
      resource.representation = subject.to_hash
      resource.save
    end

    resource
  end
end
