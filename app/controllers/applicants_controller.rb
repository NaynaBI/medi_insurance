class ApplicantsController < ApplicationController
  before_action :authenticate_agent!, except: [:new, :create]

  def index
    @applicants = current_agent.applicants
  end

  def new
    @applicant = Applicant.new
  end

  def create
    agent = current_agent || Agent.general
    agent.applicants.create(applicant_params)
    flash[:success] = "Applicant Signup Completed."
    redirect_to applicants_path
  end

  def edit
    @applicant = Applicant.find_by_id(params[:id])
    @signature = @applicant.applicant_signature || @applicant.build_applicant_signature
  end

  def update
    applicant = Applicant.find_by_id(params[:id])
    applicant.update_attributes(applicant_params)

    if params[:applicant_signature].present? && (data = params[:applicant_signature][:data]).present?
      signature = applicant.applicant_signature || applicant.build_applicant_signature
      signature.data = data
      signature.save
    end

    flash[:success] = "Applicant signed form successfully."
    redirect_to applicant_path(applicant)
  end

  def show
    @applicant = Applicant.find_by_id(params[:id])
  end

  def delete
  end

  def csv_import
    Applicant.csv_import(params[:file], current_agent)
    flash[:success] = "CSV imported successfully."
    redirect_to applicants_path
  end

  def pdf_report
    @applicant = Applicant.find_by_id(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@applicant.name}_signed_form",
               show_as_html: params.key?('debug'),
               outline: { outline: true,
                          outline_depth: 10}
      end
    end
  end

  private

  def applicant_params
    params.require(:applicant).permit(:name, :dob, :sex, :state, :country, :facility_of_residents, :medicaid_number, :medicaid_case_worker, :ss_number, :address, :email, :phone, applicant_signature: [:data])
  end
end
