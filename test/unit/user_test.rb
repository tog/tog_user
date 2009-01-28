require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
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

end