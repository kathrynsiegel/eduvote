module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def signed_in?
    !current_user.nil?
  end

  def signed_in_user
    redirect_to root_url, notice: "Please sign in." unless signed_in?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def at_signin_path?
    request.original_fullpath == signin_path ||
    request.original_fullpath == sessions_path ||
    request.original_fullpath == root_path
  end

  def instructor
    redirect_to(user_path(current_user)) unless current_user.instructor?
  end

  #  Used to determine whether an instructor has access to a question.
  def correct_instructor?(user, course)
    course.instructors.include?(current_user)
  end

  def is_today?(time)
    current_time = DateTime.current.in_time_zone("Eastern Time (US & Canada)")
    time.to_date == current_time.to_date
  end

end
