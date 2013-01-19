module OmniAuth
  module Integration
    def mock_provider(user)
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:redu] = OmniAuth::AuthHash.new({
        provider: 'redu',
        uid: user.uid,
        info: {
          name: user.name,
          login: user.login,
          email: user.email,
        },
        credentials: { token: user.token }
      })
    end

    def login_with_oauth
      visit '/auth/redu'
    end
  end
end
