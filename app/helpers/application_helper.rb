module ApplicationHelper
  def js_error(msg)
    unless msg.is_a? String
      msg = msg.errors.full_messages.first
    end
    "error('#{escape_javascript msg}');".html_safe
  end
  
  def js_notice(msg)
    "notice('#{escape_javascript msg}');".html_safe
  end
end
