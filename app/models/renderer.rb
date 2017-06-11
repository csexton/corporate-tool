# I would much rather use html-pipeline but seems like that is problematic on
# the heroku, so I am doing all this for now.
#
# https://github.com/jch/html-pipeline/issues/33
#
#
class Renderer
  def self.markdown(body)
    self.new.render_markdown(body).html_safe unless body.empty?
  end

  def self.gist(file)
    self.new.render_gist(file).html_safe unless file.body.empty?
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
    renderer = HTMLwithPygments.new(with_toc_data: true)
    markdown = Redcarpet::Markdown.new(renderer,
                                       autolink: true,
                                       fenced_code_blocks: true,
                                       footnotes: true,
                                       hard_wrap: true,
                                       lax_spacing: true,
                                       no_intra_emphasis: true,
                                       space_after_headers: true,
                                       strikethrough: true,
                                       tables: true
                                      )
    emojify(markdown.render(body))
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

