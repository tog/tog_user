class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  def admin?  
    return logged_in? && current_user.admin?
  end
  
end
