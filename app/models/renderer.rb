require 'kramdown-mermaid-rouge'

class Renderer
  # Markdown may contain raw HTML, so the rendered output is passed through an
  # allowlist sanitizer. This strips scripts, event handlers, and dangerous
  # URL schemes (e.g. javascript:) while keeping the markup kramdown, rouge,
  # mermaid, and emoji produce.
  ALLOWED_TAGS = Rails::HTML5::SafeListSanitizer.allowed_tags + %w[
    table thead tbody tfoot tr th td caption colgroup col
    details summary s strike u
    input
  ]
  # input/type/checked/disabled are for GFM task list checkboxes; forms and
  # event handlers are still stripped, so inputs can't submit or run script.
  ALLOWED_ATTRIBUTES = Rails::HTML5::SafeListSanitizer.allowed_attributes + %w[
    id style colspan rowspan align
    type checked disabled
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
    link_uploads(sanitize(emojify(Kramdown::Document.new(body, opts).to_html)))
  end

  # Page bodies written before uploads went private link straight to the
  # public S3 URL. Point those at /uploads/:id/file instead, at render time,
  # so old pages and their saved versions work without rewriting them.
  UPLOAD_LINK = /\b(href|src)="(https?:\/\/[^"]*amazonaws\.com\/[^"]*)"/

  def link_uploads(html)
    bucket = UploadProcessors::S3.bucket
    return html if bucket.blank? || !html.include?("amazonaws.com")

    keys_by_url = {}
    html.scan(UPLOAD_LINK) do |_attr, url|
      found_bucket, key = S3Url.parse(CGI.unescapeHTML(url))
      keys_by_url[url] = key if found_bucket == bucket
    end
    return html if keys_by_url.empty?

    ids_by_key = Upload.where(storage_key: keys_by_url.values.uniq).pluck(:storage_key, :id).to_h
    html.gsub(UPLOAD_LINK) do
      attr, url = $1, $2
      id = ids_by_key[keys_by_url[url]]
      id ? %(#{attr}="#{Rails.application.routes.url_helpers.file_upload_path(id)}") : $&
    end
  end

  private

  def sanitize(html)
    Rails::HTML5::SafeListSanitizer.new.sanitize(
      html, tags: ALLOWED_TAGS, attributes: ALLOWED_ATTRIBUTES
    )
  end
end
