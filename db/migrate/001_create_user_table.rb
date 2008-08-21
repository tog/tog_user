class CreateUserTable < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string   :login
      t.string   :email
      t.string   :crypted_password, :limit => 40
      t.string   :salt,             :limit => 40
      t.string   :activation_code,  :limit => 40
      t.string   :password_reset_code
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.datetime :activated_at
      t.datetime :deleted_at
      t.string   :state,            :null => :no, :default => 'passive'
      t.boolean  :admin,            :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end
end


