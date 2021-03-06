require 'csv'

class Applicant < ActiveRecord::Base
  attr_accessor :ss_number1, :ss_number2, :ss_number3

  belongs_to :agent
  has_one :applicant_signature

  validates_presence_of :email
  validates_uniqueness_of :email

  PLAN_LIST = { "A" => "A $139/month", "B" => "B $199/month", "C" => "C $139/month", "C+" => "C+ Additional $29 a month" }

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

  def docusign_client
    @docusign_client ||= DocusignRest::Client.new
  end

  def envelope_url(return_url, default_url)
    response = docusign_client.get_recipient_view(
                                     client_id: id,
                                     envelope_id: envelope_id,
                                     name: "Test Host", #host name for in person signer
                                     email: "biappstestemail@gmail.com",  #host email for in person signer
                                     return_url: return_url
                                     )
    if response["url"].present?
      return response["url"]
    else
      return default_url
    end
  end

  def get_signed_form
    response = docusign_client.get_document_from_envelope(
                                    envelope_id: envelope_id,
                                    document_id: 1,
                                    local_save_path: "#{Rails.root.join('docusign_docs/' + envelope_id + '.pdf')}"
                                    )

  end

  def get_envelope_status
    response = docusign_client.get_envelope_status(envelope_id: envelope_id)
    self.envelope_status = response["status"]
    self.save
  end
end
