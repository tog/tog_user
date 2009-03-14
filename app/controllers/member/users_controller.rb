class Member::UsersController < Member::BaseController        

  before_filter :find_user

  def change_password
    return unless request.post?
    if User.authenticate(current_user.login, params[:old_password])
      if (params[:password] == params[:password_confirmation])
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]
        if current_user.save
          flash[:ok] = I18n.t("tog_user.member.password.changed")
        else
          flash[:error] = I18n.t("tog_user.member.password.not_changed")
        end
      else
        flash[:error] = I18n.t("tog_user.member.password.mismatch")
        @old_password = params[:old_password]
      end
    else
      flash[:error] = I18n.t("tog_user.member.password.invalid")
    end
    redirect_to :action => 'my_account'
  end
  
  def destroy
    current_user.destroy
    cookies.delete :auth_token
    reset_session
    flash[:ok] = I18n.t("tog_user.member.account.removed")
    redirect_back_or_default('/')
  end

  protected

    def find_user
      @user = current_user
    end

end
