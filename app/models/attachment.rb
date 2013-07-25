class Attachment < ActiveRecord::Base
  attr_accessible :filename, :location

  belongs_to :user
  belongs_to :comment

  validates_presence_of :filename, :location, :user_id
end


