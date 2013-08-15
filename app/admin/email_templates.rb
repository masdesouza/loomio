ActiveAdmin.register EmailTemplate do
  index do
    column :name
    column :language
    column :updated_at
    actions defaults: true do |email_template|
      link_to 'Preview', preview_admin_email_template_path
    end
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
  
  show do
    user = User.loomio_helper_bot
    group = Group.find_by_name('Loomio Community')
    email_template.render(recipient: user, author: current_user, group: group)
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
