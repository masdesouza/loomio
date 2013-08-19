class Email < ActiveRecord::Base
  include Routing

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

    substitutions.each_pair do |name, value|
      self.instance_variable_set("@#{name}", value)
    end

    [:body, :subject].each do |text_name|
      in_text = self.send(text_name)
      out_text = in_text.dup

      in_text.scan(/{{(\S+)}}/) do |match|
        code = match.first
        replacement = eval(code)
        out_text.gsub!("{{#{code}}}", replacement)
      end

      self[text_name] = out_text
    end
  end

  def render_body
    options = {
      :no_intra_emphasis   => true,
      :tables              => true,
      :fenced_code_blocks  => true,
      :autolink            => true,
      :strikethrough       => true,
      :space_after_headers => true,
      :superscript         => true,
      :underline           => true
    }

    renderer = Redcarpet::Render::HTML.new(
      :filter_html         => true,
      :link_attributes     => {target: '_blank'}
    )
    markdown = Redcarpet::Markdown.new(renderer, options)
    markdown.render(body)
  end
end
