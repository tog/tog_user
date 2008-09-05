module UsersHelper
  
  def last_users(limit=16)
    users = User.find(:all,
                      :conditions => ["state = ?", 'active'],
                      :limit => limit,
                      :order => 'created_at desc')
    return if users.empty?

    users.each do |user|
      yield user
    end
  end
  
end