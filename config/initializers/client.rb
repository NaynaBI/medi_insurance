DocusignRest::Client.class_eval do
  def create_envelope_from_document(options={})
    ios = create_file_ios(options[:files])
    file_params = create_file_params(ios)

    post_body = {
      emailBlurb:   "#{options[:email][:body] if options[:email]}",
      emailSubject: "#{options[:email][:subject] if options[:email]}",
      documents: get_documents(ios),
      recipients: get_recipients(options),
      status: "#{options[:status]}"
    }.to_json

    uri = build_uri("/accounts/#{acct_id}/envelopes")

    http = initialize_net_http_ssl(uri)

    request = initialize_net_http_multipart_post_request(
                                                         uri, post_body, file_params, headers(options[:headers])
                                                         )

    response = http.request(request)
    JSON.parse(response.body)
  end

  def get_recipients(options)
    recipients = { }

    if options[:signers]
      recipients[:signers] = get_signers(options[:signers])
    end

    if options[:in_person_signers]
      recipients[:inPersonSigners] = get_in_person_signers(options[:in_person_signers])
    end

    recipients
  end

  def get_in_person_signers(in_person_signer)
    doc_signers = []

    in_person_signer.each do |signer, index|
      doc_signer = {
        hostEmail: signer[:hostEmail],
        hostName: signer[:hostName],
        recipientId: signer[:recipientId],
        signerEmail: signer[:signerEmail],
        signerName: signer[:signerName],
        embedded: signer[:embedded],
        clientUserId: signer[:clientUserId]
      }

      doc_signers << doc_signer
    end

    doc_signers
  end
end
