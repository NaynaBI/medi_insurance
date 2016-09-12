class AddFieldsToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :confirmation_token, :string
    add_column :agents, :confirmed_at, :timestamp
    add_column :agents, :confirmation_sent_at, :timestamp
    add_column :agents, :unconfirmed_email, :string
  end
end
