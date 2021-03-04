class Helper
  def self.is_logged_in?(session)
    !!session[:user_id]
  end

  def self.current_user(session)
    User.find_by(username: session[:username])
  end
end
