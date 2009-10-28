class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  filter_parameter_logging :password, :password_confirmation
  
  def admin?  
    return logged_in? && current_user.admin?
  end
  
end
