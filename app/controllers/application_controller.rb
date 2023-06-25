class ApplicationController < ActionController::Base
  before_action :set_current_user

  private

  def set_current_user
    # for now, not added any authentications like Devise here, instead relying on below assumption:
    # would need to manually set the session[:user_id] value when a user successfully logs in and clear it when the user logs out
    @current_user = User.find_by(id: session[:user_id])
  end
end
