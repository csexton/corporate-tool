module PagesHelper
  def display_page_path(page)
    "/#{page.path}"
  end
end
