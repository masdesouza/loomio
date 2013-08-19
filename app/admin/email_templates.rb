ActiveAdmin.register EmailTemplate do
  index do
    column :name
    column :language
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs "Email Template" do
      f.input :name
      f.input :language, as: :select, :collection => Translation::LANGUAGES
      f.input :subject
      f.input :body
    end
    f.buttons
  end

  show do |template|
    recipient = User.loomio_helper_bot
    group = Group.find_by_name('Loomio Community')

    @email = Email.new_from_template(template,
                                     to: "#{recipient.name} <#{recipient.email}>",
                                     from: "#{current_user.name} via Loomio <#{current_user.email}>",
                                     reply_to: "#{current_user.name} <#{current_user.email}>")

    @email.substitute_placeholders(recipient: recipient,
                                   author: current_user,
                                   group: group)
    render template: 'admin/email_templates/show', locals: {email: @email}
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

end
