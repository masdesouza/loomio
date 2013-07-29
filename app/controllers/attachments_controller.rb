class AttachmentsController < ApplicationController
  before_filter :authenticate_user!
  def index
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

end
