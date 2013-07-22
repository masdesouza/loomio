class MoveMembershipsToMembershipRequests < ActiveRecord::Migration

  class Membership < ActiveRecord::Base
    belongs_to :user, :counter_cache => true
  end

  class MembershipRequest < ActiveRecord::Base
  end

  def up
    Membership.all.each do |membership|
      if membership.access_level == "request"
        membership_request = MembershipRequest.new
        membership_request.group_id = membership.group_id
        membership_request.requestor_id = membership.user_id
        membership_request.save
        membership.destroy
      end
    end
  end

  def down

  end
end
