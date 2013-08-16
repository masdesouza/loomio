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

  def substitute_placeholders(substitutions)
    [:body, :subject].each do |text_name|
      text = self.send(text_name)

      /{{\S}}/.match(text).to_a.each do |match|

        object, method = match.split('.')
        replacement = if method.nil?
          # assume it is a url helper call
          Rails.application.routes.url_helpers.send(object)
        else
          substitutions[object].send(method)
        end

        text.gsub!("{{#{match}}}", replacement)
      end

      self[text_name] = text
    end
  end
end
