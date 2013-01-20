# Hadles the logic of fetching Space from remote REST API or from the Database
# depending on the existence of Space.
class SpaceFinderService
  include Virtus

  attribute :space_id, Integer
  attribute :user, User
  attribute :client, Redu::Client, default: lambda { |service, attr|
    Redu::Client.new(oauth_token_secret: service.user.token)
  }

  # Fetches space from database or from API
  def find
    space = Space.find_or_initialize_by_core_id(space_id)

    if space.persisted?
      space
    else
      api_space = client.space(space_id)
      space.update_attributes(api_space.attributes.slice(:name))
    end

    space
  end

end
