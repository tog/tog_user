class Admin::UsersController < Admin::BaseController        

  before_filter :find_user, :except => :index
  
  
  def index
    @order_by = params[:order_by] || "login"
    @sort_order = params[:sort_order] || "asc"
    @page = params[:page] || '1'
    
    condition = ""
    conditions_values = Hash.new
    
    if params[:search_term]
      conditions_values[:search_term] = "%#{params[:search_term]}%"
      condition = "(login like :search_term or email like :search_term)"
    end
    
    if params[:age]
      condition += " and " if condition != ""
      today = Date.today
      conditions_values[:aged] = {
        :today => today,
        :week => today - 7.days,
        :month => today - 1.month,
      }[params[:age].to_sym]
      condition += "(created_at > :aged)"
    end
    
    if params[:state]
      condition += " and " if condition != ""
      conditions_values[:state] = params[:state]
      condition += "(state = :state)"
    end    
    
    @users = User.find(:all, :order => "#{@order_by} #{@sort_order}",
                             :conditions => [condition, conditions_values]
                      ).paginate :page => @page,
                                 :per_page => Tog::Config['plugins.tog_core.pagination_size']
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
