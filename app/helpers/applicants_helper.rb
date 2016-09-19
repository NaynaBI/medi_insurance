module ApplicantsHelper
  def applicant_name_link(applicant)
    if applicant.envelope_status == "completed"
      applicant_path(applicant)
    else
      edit_applicant_path(applicant)
    end
  end
end
