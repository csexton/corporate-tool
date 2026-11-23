require 'kramdown-mermaid-rouge'

class Renderer
  # Markdown may contain raw HTML, so the rendered output is passed through an
  # allowlist sanitizer. This strips scripts, event handlers, and dangerous
  # URL schemes (e.g. javascript:) while keeping the markup kramdown, rouge,
  # mermaid, and emoji produce.
  ALLOWED_TAGS = Rails::HTML5::SafeListSanitizer.allowed_tags + %w[
    table thead tbody tfoot tr th td caption colgroup col
    details summary s strike u
  ]
  ALLOWED_ATTRIBUTES = Rails::HTML5::SafeListSanitizer.allowed_attributes + %w[
    id style colspan rowspan align
  ]

  def self.markdown(body)
    new.render_markdown(body).html_safe unless body.empty?
  end

  def emojify(content)
    content.to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
      if Emoji.find_by_alias($1)
        '<img alt="' + $1 + '" height="20" src="/images/emoji/' + $1 + '.png" style="vertical-align:middle" width="20" />'
      else
        match
      end
    end if content.present?
  end

  def highlightify(content, lang)
    lexer = ::Rouge::Lexer.find_fancy(lang, content)
    formatter = Rouge::Formatters::HTML.new
    formatter = Rouge::Formatters::HTMLTable.new(formatter)
    formatter = Rouge::Formatters::HTMLPygments.new(formatter, css_class='rouge-wrapper')
    formatter.format(lexer.lex(content))
  end

  def render_markdown(body)
    opts = { input: 'GFM', syntax_highlighter: :mermaid_rouge}
    sanitize(emojify(Kramdown::Document.new(body, opts).to_html))
  end

  private

  def sanitize(html)
    Rails::HTML5::SafeListSanitizer.new.sanitize(
      html, tags: ALLOWED_TAGS, attributes: ALLOWED_ATTRIBUTES
    )
  end
end
