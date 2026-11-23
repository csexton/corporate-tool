module SearchHelper
  def model_type_checked(model)
    if model == params.fetch(:t) { "Any" }
      "checked"
    else
      nil
    end
  end

  # Escapes a line of page source and wraps each occurrence of the query in
  # <strong>, without ever treating the line or query as HTML.
  def highlight_match(line, query)
    safe_join(line.split(query, -1), content_tag(:strong, query))
  end
end
