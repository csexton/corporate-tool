module ApplicationHelper
  def render_gist(gist)
    ::Renderer.gist gist
  end

  def render_page(page)
    ::Renderer.markdown page.body
  end
end
