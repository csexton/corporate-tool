module PagesHelper
  def display_page_path(page)
    "/#{page.path}"
  end

  def version_date(version)
    version.created_at.strftime("%e %b %Y %H:%M:%S%p")
  end

  def version_user(version)
    User.find(version.whodunnit).name
  end
end
