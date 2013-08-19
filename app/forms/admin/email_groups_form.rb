class EmailGroupsForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  def submit(params, current_user)
    if valid?
      email_template = EmailTemplate.find params[:email_template_id]
      groups = Group.find params[:group_ids]
      groups.each do |group|
        @recipients = case params[:recipients]
                      when 'contact_person'
                        group.map(&:contact_person)
                      when 'coordinators'
                        group.coordinatiors
                      when 'members'
                        group.members
                      end

        recipient_names_and_emails = recipients.map do |recipient|
          "#{recipient.name} <#{recipient.email}>"
        end

        sender = "#{current_user.name} <#{current_user.email}>"
        reply_to = "#{parms[:reply_to_name]} <#{params[:reply_to_email}>"
        Email.new_from_template(email_template, to: recipient_names_and_emails,
                                                from: sender,
                                                reply_to: reply_to)
        email.substitute_placeholders(group: group, author: current_user)
        EmailTemplateMailer.delay.basic(email)
      end
    else
    end
  end


end
