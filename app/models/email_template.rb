class EmailTemplate < ActiveRecord::Base
  include Routing

  def generate_email(args)
    headers = args[:headers]
    placeholders = args[:placeholders]

    email = Email.new
    email.subject = substitute_placeholders(subject, placeholders)
    email.body = substitute_placeholders(body, placeholders)
    email.language = language
    email.to = headers[:to]
    email.from = headers[:from]
    email.reply_to = headers[:reply_to]
    email
  end

  def substitute_placeholders(in_text, placeholders)
    placeholders.each_pair do |name, value|
      self.instance_variable_set("@#{name}", value)
    end

    out_text = in_text.dup

    in_text.scan(/{{(\S+)}}/) do |match|
      code = match.first
      replacement = eval(code)
      out_text.gsub!("{{#{code}}}", replacement)
    end

    out_text
  end
end
