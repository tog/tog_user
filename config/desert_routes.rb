# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

# resources :tog_users
                                                                            
resources :users
resource  :session

login    '/login',    :controller => 'sessions', :action => 'new'
logout   '/logout',   :controller => 'sessions', :action => 'destroy'
signup   '/signup',   :controller => 'users',    :action => 'new'
forgot   '/forgot',   :controller => 'users',    :action => 'forgot'
denied   '/denied',   :controller => 'authorization',    :action => 'denied'
reset    '/reset/:reset_code',          :controller => 'users', :action => 'reset'
activate '/activate/:activation_code',  :controller => 'users', :action => 'activate'
resend_activation '/resend_activation', :controller => 'users', :action => 'resend_activation'

namespace(:admin) do |admin| 
  admin.resources :users
end

namespace(:member) do |member|
  member.with_options(:controller => 'users') do |user|
    user.my_account       '/account',         :action => 'my_account'
    user.destroy_account  '/destroy',         :action => 'destroy'
    user.change_password  '/change_password', :action => 'change_password', :conditions => { :method => :post }
  end
end