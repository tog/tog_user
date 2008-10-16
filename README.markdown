Tog User
========

Tog user management

Included functionality
-----------------------

* Login, logout and signup processes
* Password reminder
* Activation process
* recaptcha support
* User login or email as key
* Administration interface

Resources
=========

Plugin requirements
-------------------

* https://github.com/tog/tog/wikis/3rd-party-plugins-acts_as_state_machine


Install
-------

If you used the command <code>togify</code> to install tog, then you already have tog_user installed.

If not, install it like any other plugin:

  
* Install plugin form source:

<pre>
ruby script/plugin install git@github.com:tog/tog_user.git
</pre>

* Generate installation migration:

<pre>
ruby script/generate migration install_tog_user
</pre>

	  with the following content:

<pre>
class InstallTogUser < ActiveRecord::Migration
  def self.up
    migrate_plugin "tog_user", 1
  end

  def self.down
    migrate_plugin "tog_user", 0
  end
end
</pre>

* Add tog_social's routes to your application's config/routes.rb

<pre>
map.routes_from_plugin 'tog_user'
</pre> 

* And finally...

<pre> 
rake db:migrate
</pre> 

More
-------

[http://github.com/tog/tog_social](http://github.com/tog/tog_user)

[http://github.com/tog/tog_social/wikis](http://github.com/tog/tog_user/wikis)


Copyright (c) 2008 Keras Software Development, released under the MIT license