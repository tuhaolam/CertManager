class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.binary :password_hash, null: false
      t.binary :password_salt, null: false
      t.boolean :can_login, null: false, default: false

      t.timestamps null: false
    end
  end
end