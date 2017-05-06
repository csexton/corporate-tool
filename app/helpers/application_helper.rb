module ApplicationHelper
  def render_gist(gist)
    ::Renderer.gist gist
  end

  def render_page(page)
    ::Renderer.markdown page.body
  end

  def active_if(item)
    name = controller.controller_name
    action = controller.action_name

    case item
    when "gists/new"
      "active" if name == "gists" && action == "new"
    when "pages/new"
      "active" if name == "pages" && action == "new"
    when "pages"
      "active" if name == "pages" && action == "index"
    when "welcome"
      "active" if name == "welcome"
    end
  end


  def bootstrap_class_for flash_type
    {
      success: 'alert-success',
      error: 'alert-error',
      alert: 'alert-block',
      notice: 'alert-info',
    }.fetch(flash_type.to_sym){ flash_type }
  end

  def site_name
    ENV.fetch('SITE_NAME') { "Corporate Tool" }
  end

  def avatar_path(user)
    if user.avatar_url.blank?
      md5 = Digest::MD5.hexdigest(user.email.downcase)
      "https://www.gravatar.com/avatar/#{md5}.png?s=50&d=identicon&r=PG"
    else
      user.avatar_url
    end
  end

end
