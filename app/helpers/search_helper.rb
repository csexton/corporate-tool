module SearchHelper
  def model_type_checked(model)
    if model == params.fetch(:t) { "Any" }
      "checked"
    else
      nil
    end
  end
end
