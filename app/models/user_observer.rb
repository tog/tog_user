class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(reload_user(user))
  end

  def after_save(user)
    u = reload_user(user)
    UserMailer.deliver_activation(u) if u.recently_activated?
    UserMailer.deliver_reset_notification(u) if u.recently_forgot_password?
  end

  private
    def reload_user(user)
      User.find(user.id)
    end
end
