class Admin::UsersController < Admin::BaseController        

  before_filter :find_user
  
  def index
    @users = User.paginate :per_page => Tog::Config['plugins.tog_core.pagination_size'], :page => params[:page], :order => 'login'
  end

  def new       
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    @user.make_activation_code
    @user.save!
    redirect_to(admin_users_url)
    flash[:ok] = I18n.t("tog_user.admin.user_created", :login => @user.login)
  rescue ActiveRecord::RecordInvalid
    flash[:error] = @title = I18n.t("tog_user.admin.error_saving")
    render :action => 'new'
  end

  def update
    @user.send(%{#{params[:state_event]}!}) unless params[:state_event].blank?
    @user.admin = params[:user][:admin]
    @user.update_attributes!(params[:user])
    redirect_to(admin_users_url)
    flash[:ok] = I18n.t("tog_user.admin.user_updated", :login => @user.login)
  rescue ActiveRecord::RecordInvalid
    flash[:error] = I18n.t("tog_user.admin.error_saving")
    render :action => 'edit'
  end

  protected

  def find_user
    @user = User.find(params[:id]) if params[:id]
  end

end
