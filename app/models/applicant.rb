require 'csv'

class Applicant < ActiveRecord::Base
  belongs_to :agent
  has_one :applicant_signature

  validates_presence_of :email
  validates_uniqueness_of :email

  def self.csv_import(file, agent)
    CSV.foreach(file.path, headers: true) do |row|
      applicant_hash = row.to_hash
      email = applicant_hash["Email"]

      applicant = Applicant.find_by_email(email) || agent.applicants.new(email: email)
      applicant.name = applicant_hash["Name"]
      applicant.dob = applicant_hash["DOB"]
      applicant.sex = applicant_hash["Sex"]
      applicant.state = applicant_hash["State"]
      applicant.country = applicant_hash["Country"]
      applicant.facility_of_residents = applicant_hash["Facility of Residents"]
      applicant.medicaid_number = applicant_hash["Medicaid Number"]
      applicant.medicaid_case_worker = applicant_hash["Medicaid Case Worker"]
      applicant.ss_number = applicant_hash["SS Number"]
      applicant.address = applicant_hash["Address"]
      applicant.phone = applicant_hash["Phone"]
      applicant.save
    end
  end
end
