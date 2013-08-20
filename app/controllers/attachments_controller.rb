class AttachmentsController < ApplicationController
  before_filter :authenticate_user!
  # def index
  # end

  def sign
    render json: {
      policy: s3_upload_policy_document,
      signature: s3_upload_signature,
      key: "uploads/#{SecureRandom.uuid}/#{params[:doc][:title]}",
      success_action_redirect: "/"
    }
  end

  def create
    filename = params[:filename]
    location = params[:location]
    filesize = params[:filesize]
    attachment = Attachment.new(filename: filename, location: location, filesize: filesize)
    attachment.user = current_user

    if attachment.save
      render json: {
        saved: true,
        attachmentId: attachment.id
      }
    else
      render json: {
        saved: false
      }
    end
  end

  private

  # generate the policy document that amazon is expecting.
  def s3_upload_policy_document
    Base64.encode64(
      {
        expiration: 30.minutes.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
        conditions: [
          { bucket: ENV['S3_BUCKET'] },
          { acl: 'public-read' },
          [ "starts-with", "$key", "uploads/" ],
          { success_action_status: '201' },
          [ "starts-with", "$Content-Type", "" ],
          [ "content-length-range", 0, 52428800 ]
        ]
      }.to_json
    ).gsub(/\n|\r/, '')
  end

  # sign our request by Base64 encoding the policy document.
  def s3_upload_signature
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        ENV['AWS_SECRET_ACCESS_KEY'],
        s3_upload_policy_document
      )
    ).gsub(/\n/, '')
  end
end
