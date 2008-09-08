# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  
  helper :core
  
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_login"]) #last_recipes_path
      flash[:ok] = "Logged in successfully."
    else
      flash[:error] = "Incorrect username or password."
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:ok] = "You are now signed out."
    redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_logout"])
  end
end
