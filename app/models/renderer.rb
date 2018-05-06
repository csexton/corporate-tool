# I would much rather use html-pipeline but seems like that is problematic on
# the heroku, so I am doing all this for now.
#
# https://github.com/jch/html-pipeline/issues/33
#
#
class Renderer
  def self.markdown(body)
    new.render_markdown(body).html_safe unless body.empty?
  end

  def self.gist(file)
    new.render_gist(file).html_safe unless file.body.empty?
  end

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end
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

  def render_markdown(body)
    opts = {input: 'GFM', syntax_highlighter: :rouge}
    emojify(Kramdown::Document.new(body, opts).to_html)
  end

  def render_gist(gist)
    if gist.file_type == 'markdown'
      render_markdown gist.body
    else
      Pygments.highlight(gist.body,
                         lexer: gist.file_type,
                         options: {linenos: 'table'})
    end
  end
end

