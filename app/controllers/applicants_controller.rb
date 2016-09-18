class ApplicantsController < ApplicationController
  before_action :authenticate_agent!, except: [:new, :create, :send_form]

  def index
    if current_agent.admin?
      @applicants = Applicant.all
    else
      @applicants = current_agent.applicants
    end
  end

  def new
    @applicant = Applicant.new
  end

  def create
    agent = current_agent || Agent.find_by_email("info@businessinsighter.com")
    @applicant = agent.applicants.new(applicant_params)

    if @applicant.save
      redirect_to send_form_applicant_path(@applicant)
    else
      flash[:error] = @applicant.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @applicant = Applicant.find_by_id(params[:id])
    @signature = @applicant.applicant_signature || @applicant.build_applicant_signature
  end

  def capture_signature
    @applicant = Applicant.find_by_id(params[:id])

    unless @applicant.envelope_id.present?
      client = DocusignRest::Client.new
      response = client.create_envelope_from_document(
        email: {
          subject: "Dentsured form",
          body: "Please go through the document and sign."
        },
        in_person_signers: [{
          embedded: true,
          hostEmail: "biappstestemail@gmail.com",
          hostName: "Test Host",
          recipientId: @applicant.id,
          signerName: @applicant.name,
          signerEmail: @applicant.email,
          clientUserId: @applicant.id
        }],
        files: [
          {path: "#{Rails.root}/public/form.pdf", name: 'form.pdf'}
        ],
        status: 'sent')
      @applicant.envelope_id = response["envelopeId"]
      @applicant.envelope_status = response["status"]
      @applicant.save

    end
  end

  def update
    applicant = Applicant.find_by_id(params[:id])
    applicant.update_attributes(applicant_params)

    redirect_to capture_signature_applicant_path(applicant)
  end

  def show
    @applicant = Applicant.find_by_id(params[:id])
  end

  def delete
  end

  def signature_confirmation
    @applicant = Applicant.find_by_id(params[:id])

    client = DocusignRest::Client.new
    response = client.get_envelope_recipients(
                                              envelope_id: @applicant.envelopeId,
                                              include_tabs: true,
                                              include_extended: true
                                              )
    @applicant.envelope_status = response["inPersonSigners"][0]["status"]
    @applicant.save

    render layout: false
  end

  def csv_import
    Applicant.csv_import(params[:file], current_agent)
    flash[:success] = "CSV imported successfully."
    redirect_to applicants_path
  end

  def send_form
    applicant = Applicant.find_by_id(params[:id])

    client = DocusignRest::Client.new
    document_envelope_response = client.create_envelope_from_document(
      email: {
       subject: "Dentsured form",
       body: "Please go through the document and sign."
      },
    signers: [
    {
      name: applicant.name,
      email: applicant.email, #'biappstestemail@gmail.com'
      role_name: 'Applicant'
    }
  ],
  files: [
    {path: "#{Rails.root}/public/form.pdf", name: 'form.pdf'}
  ],
  status: 'sent')

    flash[:notice] = "Thank you for submitting form..."

    if current_agent
      redirect_to applicants_path
    else
      redirect_to policies_path
    end
  end

  def get_signed_form
    @applicant = Applicant.find_by_id(params[:id])

    if @applicant.envelope_id.present?
      @applicant.get_signed_form
      @filename = "docusign_docs/" + "#{@applicant.envelope_id}.pdf"
      @file = "#{Rails.root.join(@filename)}"
      Aws.config.update(
                        credentials: Aws::Credentials.new(Figaro.env.AWS_ACCESS_KEY_ID, Figaro.env.AWS_SECRET_ACCESS_KEY),
                        region: 'us-west-2'
                        )
      s3_bucket = Aws::S3::Bucket.new(name: "dentsures",region: "us-west-2")
      obj = s3_bucket.object(@filename)
      obj.upload_file(@filename, acl: 'public-read')
      @applicant.signed_form_path = obj.public_url
      @applicant.save
    end
  end

  private

  def applicant_params
    params.require(:applicant).permit(:name, :middle_initial, :last_name, :dob, :sex, :state, :city, :zip, :country, :facility_of_residents, :medicaid_number, :medicaid_case_worker, :ss_number, :address, :email, :phone, :communication_preference, :plan, :primary_dentist_name, :primary_dentist_telephone, applicant_signature: [:data])
  end
end
