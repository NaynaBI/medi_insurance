class DeviseCreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.string :name
      t.text :address
      t.string :phone
      t.integer :communication_preference, limit: 1
      t.timestamps null: false
    end

    add_index :agents, :email,                unique: true
    add_index :agents, :reset_password_token, unique: true
  end
end
