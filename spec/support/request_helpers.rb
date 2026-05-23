module RequestHelpers
  def login(user, password: 'password')
    post login_path, params: {
      session: {
        email: user.email,
        password: password
      }
    }
  end
end
