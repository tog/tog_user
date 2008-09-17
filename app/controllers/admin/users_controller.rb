class Admin::UsersController < Admin::BaseController        

  before_filter :find_user
  
  def index
    @users = User.paginate :per_page => 20, :page => params[:page], :order => 'login'
  end

  def new       
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    @user.make_activation_code
    @user.save!
    redirect_to(admin_users_url)
    flash[:ok] = "User #{@user.login} created successfully!"
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Some error prohibited to save this user"
    render :action => 'new'
  end

  def update
    @user.send(%{#{params[:state_event]}!}) unless params[:state_event].blank?
    @user.admin = params[:user][:admin]
    @user.update_attributes!(params[:user])
    redirect_to(admin_users_url)
    flash[:ok] = "User #{@user.login} updated successfully!"
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Some error prohibited to update this user"
    render :action => 'edit'
  end

  protected

  def find_user
    @user = User.find(params[:id]) if params[:id]
  end

end
