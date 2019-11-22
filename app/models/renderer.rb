class Renderer
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
    opts = { input: 'GFM', syntax_highlighter: :rouge }
    emojify(Kramdown::Document.new(body, opts).to_html)
  end
end
