class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # So it's OK for this to be null.  awesome.
      # Why do you not use any DB constraints
      t.string :username
      t.string :password_digest
      t.string :walk_speed, default: "normal"
      t.string :phone_number
      t.string :email
      t.timestamps
    end
  end
end
