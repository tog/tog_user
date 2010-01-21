require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  
  context "A visitor" do
    context "that filling sign up form" do

      Tog::Config["plugins.tog_user.email_as_login"] = 'false'

      user = User.new(
        :login=> '2',
        :email=> 'email@mail.com',
        :password => '123',
        :password_confirmation => '123'
      )
      user.save

      should 'be verifyed with login field if we don\'t use email_as_login' do
        assert_equal true, user.errors.invalid?(:login) 
      end

      should 'not be verifyed with login field if we use email_as_login' do
        Tog::Config["plugins.tog_user.email_as_login"] = 'true'
        user.save
        assert_equal false, user.errors.invalid?(:login) 
      end
      
      Tog::Config['plugins.tog_user.email_as_login'] = 'true'
      
      should 'shouldn\'t use short email' do
        user.attributes = {:email => 'm@l.c'}
        user.save
        assert_equal true, user.errors.invalid?(:email)
      end
     
      should 'should fill correct email' do
        broken_emails = [
          'test@mail.',
          'test@mail',
          'test@.com',
          '@mail.com'
        ]
        
        broken_emails.each do |val|
          user.attributes = {:email => val}
          user.save
          assert_equal true, user.errors.invalid?(:email), "'#{val}' email became as valid'"
        end
      end
      
      should 'should be accepted with approptiate email' do
        user.attributes = {:email => 'asdgq@qwlk.com'}
        user.save
        assert_equal false, user.errors.invalid?(:email)
      end

      should 'shouldn\'t be accepted with too short password' do
        user.attributes = { :password => '123',:password_confirmation => '123' }
        user.save
        assert_equal true, user.errors.invalid?(:password)
      end

      should 'shouldn\'t be accepted with wrong password confirmation' do
        user.attributes = { :password => '123456',:password_confirmation => '123654' }
        user.save
        assert_equal true, user.errors.invalid?(:password)
      end
      
      should 'should be accepted with all fields filled correctly' do
        user.attributes = {
          :email => 'email@mail.com',
          :password => '123456',
          :password_confirmation => '123456' 
        }
        user.save
        assert_equal true, user.errors.empty?
      end      
    end
    
    context "that signs up" do
      setup do
        @chavez = Factory(:user, :login => 'chavez')
      end

      should "be in state pending" do
        assert @chavez.state, "pending"
      end
          
      should "generate an activation_code" do
        assert_not_nil @chavez.activation_code
      end
    
      should "receive an email with a link to activation" do
        assert_sent_email do |email|
          email.body.include? @chavez.activation_code
          email.subject.include?(I18n.t("tog_user.mailer.activate_account"))
        end
      end
      
      context "and activates his acount" do
        setup do
          @chavez.activate!
        end

        should "report activity" do
          assert_not_nil Activity.by_user(@chavez).find_by_action('activate')
        end
        
        should "be in state active" do
          assert @chavez.state, "active"
        end

        should "receive a welcome message" do
          assert_sent_email do |email|
            email.subject.include?(I18n.t("tog_user.mailer.account_activated"))
          end
        end

      end      
    
    end
  end
  

  context "A User" do

    setup do
      @chavez = Factory(:user, :login => 'chavez')
      @chavez.activate!
    end

    context "that has forgotten his password" do
      setup do
        @chavez.forgot_password
      end
    
      should "generate a password_reset_code" do
        assert_not_nil @chavez.password_reset_code
      end
    
      should "receive an email with a link to reset the password" do
        assert_sent_email do |email|
          email.body.include? @chavez.password_reset_code
          email.subject.include?(I18n.t("tog_user.mailer.reset_password"))
        end
      end
    
    end
  end
 

  context "Users" do
    setup do 
      User.destroy_all
      now = Time.now
      @user1 = Factory(:user, :login => 'user1', 
                              :email => 'user1@server.org',
                              :created_at => now)
      @user1.activate!                            
      @user2 = Factory(:user, :login => 'user2', 
                              :email => 'user2@server.org',
                              :created_at => now - 2.days)
      @user2.activate!
      @user2.suspend!                            
      @user3 = Factory(:user, :login => 'user3', 
                              :email => 'user3@otherserver.org',
                              :created_at => now - 15.days)
    end
  end
end
