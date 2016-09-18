class AddNewColumnsToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :first_name, :string
    add_column :applicants, :middle_initial, :string
    add_column :applicants, :last_name, :string
    add_column :applicants, :city, :string
    add_column :applicants, :zip, :string
    add_column :applicants, :medical_representative, :string
    add_column :applicants, :signed_form_path, :string
    add_column :applicants, :communication_preference, :string
    add_column :applicants, :plan, :string
    add_column :applicants, :primary_dentist_name, :string
    add_column :applicants, :primary_dentist_telephone, :string
  end
end
