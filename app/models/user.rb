require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  named_scope :admin, :conditions => {:admin => true}
  named_scope :active, :conditions => {:state => 'active'}
  
  has_many :comments

  after_create :send_activation_request
  after_save :send_activation_or_reset_mail


  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    if Tog::Config["plugins.tog_user.email_as_login"]
      login_column = :email
    else
      login_column = :login
    end
    u = find_in_state :first, :active, :conditions => { login_column => login} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end  

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    # First update the password_reset_code before setting the
    # reset_password flag to avoid duplicate email notifications.
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end
  
  #used in mailer
  def recently_forgot_password?
    @forgotten_password
  end

  def recently_reset_password?
    @reset_password
  end
  
  #HACK. Needed by tog_mail, which includes a filter for crating default folders after activation
  def recently_activated?
    @activated
  end

  protected
    
    def make_activation_code
        self.deleted_at = nil
        self.activation_code = self.class.make_token
    end
    
    def make_password_reset_code
      self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
      save(false)
    end    
    
    def send_activation_request
      UserMailer.deliver_signup_notification(self)
    end

    def send_activation_or_reset_mail
      UserMailer.deliver_activation(self) if self.recently_activated?
      Activity.report(self, :activate, self) if self.recently_activated?
      UserMailer.deliver_reset_notification(self) if self.recently_forgot_password?       
    end

end


  # validates_presence_of     :login, :message => I18n.t("tog_user.model.login_required")
  # validates_presence_of     :email, :message => I18n.t("tog_user.model.email_required")
  # validates_presence_of     :password,                   :if => :password_required?, :message => I18n.t("tog_user.model.password_required")
  # validates_presence_of     :password_confirmation,      :if => :password_required?
  # validates_length_of       :password, :within => 4..40, :if => :password_required?
  # validates_confirmation_of :password,                   :if => :password_required?, :message => I18n.t("tog_user.model.password_mismatch")
  # validates_length_of       :login,    :within => 3..40, :message => I18n.t("tog_user.model.login_to_short")
  # validates_length_of       :email,    :within => 3..100
  # validates_uniqueness_of   :login, :case_sensitive => false, :message => I18n.t("tog_user.model.login_in_use")
  # validates_uniqueness_of   :email, :case_sensitive => false, :message => I18n.t("tog_user.model.email_in_use")
