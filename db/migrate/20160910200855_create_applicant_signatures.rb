class CreateApplicantSignatures < ActiveRecord::Migration
  def change
    create_table :applicant_signatures do |t|
      t.binary :data
      t.has_attached_file :image
      t.belongs_to :applicant
      t.timestamps null: false
    end
  end
end
