module ApplicationHelper
  def js_error(model)
    "error('#{escape_javascript model.errors.full_messages.first}');"
  end
end
