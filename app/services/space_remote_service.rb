class SpaceRemoteService < RemoteService
  attribute :resource, Space
  attribute :user, User

  # Fetches the space users from Redu API
  def users
    client.users(space_id: resource.core_id)
  end
end
