Edge
----

0.5.1
----
* Record activity on activate
* Small fix: "system.user.email_as_login" should be "plugins.tog_user.email_as_login"
* Translated user_mailer activation and signup emails into spanish
* Improved spanish translations

0.5.0
----

* Fixed bug in user authentication when using email for login (kudos to Gaizka)
* (almost) Full i18n (kudos to Andrei Erdoss)
* Renamed routes.rb to desert_routes.rb (Rails 2.3 + desert 0.5 support)
* Small changes to code and test (Rails 2.3 support, kudos to Andrei Erdoss)
* Renamed application.rb to application_controller.rb (Rails 2.3 support)
* Small changes to code and test (Rails 2.3 support, kudos to Andrei Erdoss)
* New named_scope "admin" in user model


Fix User.authenticate when Tog::Config["plugins.tog_user.email_as_login"] 
is set

0.4.4
----

0.4.3
----

0.4.2
----
* Ticket #130. Update i18n for user's states
* Ticket #118. i18n in navigation tabs
* Fixed a nasty bug on password reminder mailer introduced by a nasty bug on restful_autenthicated introduced by ... [#121 state:resolved]

0.4.0
----
* Site-Search integration.
* Sync tog's i18n implementation with rails 2.2.2
* Only pending users should be displayed on the profiles section
* fix restful-authentication with rails 2.2

0.3.0
----
* Fixed mixed up signup/activation templates.
* Use Tog::Config['plugins.tog_core.pagination_size'] as default pagination size.
* Moved users_helper to tog_core
* Internationalization for controller and mailer message