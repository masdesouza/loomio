class Email < ActiveRecord::Base

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
