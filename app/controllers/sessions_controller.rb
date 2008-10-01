# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  
  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_login"]) #last_recipes_path
      flash[:ok] = I18n.t("tog_user.sessions.login_success")
    else
      flash[:error] = I18n.t("tog_user.sessions.login_failure")
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:ok] = I18n.t("tog_user.sessions.sign_out")
    redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_logout"])
  end

end
