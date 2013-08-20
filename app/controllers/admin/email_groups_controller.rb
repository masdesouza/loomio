class Admin::EmailGroupsController < Admin::BaseController
  def new
    @email_groups_form = Admin::EmailGroupsForm.new
    @email_groups_form.from = current_user.name_and_email
    @email_groups_form.reply_to = current_user.name_and_email
    @email_groups_form.group_ids = params[:group_ids]
    @email_groups_form.author_id = current_user.id
  end

  def create
    @email_groups_form = Admin::EmailGroupsForm.new(params[:admin_email_groups_form])
    if @email_groups_form.valid?
      generate_emails(@email_groups_form)

    else
      raise [params[:admin_email_groups_form], @email_groups_form.inspect].inspect
      render :new
    end

  end

  protected
  def generate_emails(form)
    email_template = EmailTemplate.find form.email_template_id
    groups = Group.find form.group_ids
    author = User.find(form.author_id)

    groups.each do |group|
      recipients = case form.recipients
                    when 'contact_person'
                      [group.contact_person]
                    when 'coordinators'
                      group.coordinators
                    when 'members'
                      group.members
                    else
                      raise "recipient not found #{form.recipients}"
                    end

      recipients.uniq.compact.each do |recipient|
        email = email_template.generate_email(headers: {to: recipient.name_and_email,
                                                        from: form.from,
                                                        reply_to: form.reply_to},
                                              placeholders: {group: group,
                                                             author: author,
                                                             recipient: recipient})
        email.save
      end
    end
    redirect_to admin_emails_path
  end
end
