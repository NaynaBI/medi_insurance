class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.string :name, null: false
      t.date :dob
      t.string :sex, limit: 6
      t.string :state
      t.string :country
      t.string :facility_of_residents
      t.string :medicaid_number
      t.string :medicaid_case_worker
      t.string :ss_number
      t.string :address
      t.string :email
      t.string :phone
      t.belongs_to :agent
      t.string :timestamp, null: false
    end
  end
end
