module SessionHelper
  def logged_in?
    !!session[:user_id]
  end

  # Where are you getting these names?  Why not current_user
  def correct_user
    User.find(session[:user_id]) if logged_in?
  end
end
