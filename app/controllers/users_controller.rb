class UsersController < ApplicationController
  layout "sessions"

  helper :core
  
  def new
  end

  def create
    # cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.login ||= @user.email if Tog::Config["plugins.tog_user.email_as_login"]
    
    captcha_validated = Tog::Config["plugins.tog_user.captcha_enabled"] ? verify_recaptcha(@user) : true
    
    # If there is no users yet, set the first one to admin.
    @user.admin = User.find(:all).blank?
    
    @user.register! if captcha_validated && @user.valid?
    if @user.errors.empty?
      redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_signup"])
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  
  def resend_activation
    if current_user
      UserMailer.deliver_signup_notification(current_user)
      flash[:notice] = "We have resend the activation message. Please, follow the instructions detailed in it."
    end
    redirect_to root_path
  end
  
  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_activation"])
  end

  def forgot
    if request.post?
      user = User.find_by_email(params[:user][:email])
      if user
        user.forgot_password

        flash[:notice] = "We have send an email with instructions to reset your password to #{user.email}"
      else
        flash[:notice] = "#{params[:user][:email]} doesn't have an account in this system"
      end
      redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_forgot"])
    end
  end
  
  def reset
    @user = User.find_by_password_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if request.post?
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        @user.reset_password
        self.current_user = @user
        flash[:notice] = "Password successfully updated for #{@user.email}"
        redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_reset"])
      else
        render :action => :reset
      end
    end
  end

end
