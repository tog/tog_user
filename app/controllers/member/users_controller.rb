class Member::UsersController < Member::BaseController        

  before_filter :find_user

  def change_password
    return unless request.post?
    if User.authenticate(current_user.login, params[:old_password])
      if (params[:password] == params[:password_confirmation])
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]
        if current_user.save
          flash[:ok] = "Password changed"
        else
          flash[:error] = "Password not changed"
        end
      else
        flash[:error] = "New password mismatch. Please, confirm that you entered the same in 'password' and 'password confirmation'"
        @old_password = params[:old_password]
      end
    else
      flash[:error] = "Wrong password. The current password you introduced is not valid."
    end
    redirect_to :action => 'my_account'
  end
  
  def destroy
    current_user.destroy
    cookies.delete :auth_token
    reset_session
    flash[:ok] = "Your account has been destroyed. Thank you for using our site."
    redirect_back_or_default('/')
  end

  protected

    def find_user
      @user = current_user
    end

end
