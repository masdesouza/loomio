class AttachmentsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def create
    p params
    p params[:location].length
    attachment = Attachment.new(filename: params[:filename], location: params[:location])  #refactor
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
