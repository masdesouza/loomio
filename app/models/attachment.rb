class Attachment < ActiveRecord::Base
  attr_accessible :filename, :address

  validates_presence_of :filename, :address, :user_id
end


