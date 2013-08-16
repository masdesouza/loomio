class Email < ActiveRecord::Base
  def self.new_from_template(template, headers)
    email = new
    email.subject = template.subject
    email.body = template.body
    email.language = template.language
    email.to = headers[:to]
    email.from = headers[:from]
    email.reply_to = headers[:reply_to]
    email
  end
end
