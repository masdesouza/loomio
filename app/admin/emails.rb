ActiveAdmin.register Email do
  actions :index, :show, :edit, :update, :destroy

  index do
    selectable_column
    column :to
    column :from
    column :subject
    column :created_at
    column :updated_at
    default_actions
  end

  show do |email|
    render template: 'admin/emails/show', locals: {email: email}
  end

  batch_action :send do |email_ids|
    Email.where(id: email_ids).each do |email|
      EmailTemplateMailer.delay.basic(email)
    end
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

end
