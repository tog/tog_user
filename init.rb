require_plugin 'tog_core'
require_plugin 'acts_as_state_machine'

Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_path << file
end

Tog::Plugins.settings :tog_user,  :captcha_enabled                  => false,
                                  :email_as_login                   => false,
                                  :default_redirect_on_login        => "/",
                                  :default_redirect_on_logout       => "/",
                                  :default_redirect_on_signup       => "/",
                                  :default_redirect_on_activation   => "/",
                                  :default_redirect_on_forgot       => "/",
                                  :default_redirect_on_reset        => "/"

require "acts_as_state_machine_patch"

Tog::Plugins.helpers UserHelper

Tog::Search.sources << "User"
Tog::Plugins.observers << :user_observer

Tog::Interface.sections(:admin).add "Users", "/admin/users"
Tog::Interface.sections(:member).add "My account", "/member/account"