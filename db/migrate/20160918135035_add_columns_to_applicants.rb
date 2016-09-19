class AddColumnsToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :envelope_id, :string
    add_column :applicants, :envelope_status, :string
  end
end
