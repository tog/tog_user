class Admin::UsersController < Admin::BaseController        

  before_filter :find_user
  
  helper :core
  

  def index
    @users = User.paginate :per_page => 20, :page => params[:page], :order => 'login'
  end

  def show
  end  

  def new       
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    @user.make_activation_code
    @user.save!
    redirect_to(admin_users_url)
    flash[:notice] = "User #{@user.login} created successfully!"
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = "Some error prohibited to save this user"
    render :action => 'new'
  end

  def edit
  end

  def update
    @user.send(%{#{params[:state_event]}!}) unless params[:state_event].blank?
    @user.admin = params[:user][:admin]
    @user.update_attributes!(params[:user])
    redirect_to(admin_users_url)
    flash[:notice] = "User #{@user.login} updated successfully!"
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = "Some error prohibited to update this user"
    render :action => 'edit'
  end

  #def activate
  #  @user = User.find(params[:id])
  #  @user.activate! 
  #  render :action => 'show'
  #end
  #
  #def suspend
  #  @user = User.find(params[:id])
  #  @user.suspend! 
  #  render :action => 'show'
  #end
  #
  #def unsuspend
  #  @user = User.find(params[:id])
  #  @user.unsuspend! 
  #  render :action => 'show'
  #end

  protected

  def find_user
    @user = User.find(params[:id]) if params[:id]
  end

end
