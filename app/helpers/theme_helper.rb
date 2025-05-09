module ThemeHelper
  # Helper method to generate theme color classes
  def theme_color(type, color, variant = "500")
    case type
    when :text
      "text-#{color}-#{variant}"
    when :bg
      "bg-#{color}-#{variant}"
    when :border
      "border-#{color}-#{variant}"
    else
      ""
    end
  end
  
  # Helper method to generate theme button classes
  def theme_button(style = :primary, additional_classes = "")
    base_class = "theme-btn"
    style_class = "theme-btn-#{style}"
    
    "#{base_class} #{style_class} #{additional_classes}".strip
  end
  
  # Helper method to generate theme card classes
  def theme_card(additional_classes = "")
    "theme-card #{additional_classes}".strip
  end
  
  # Helper method to generate theme input classes
  def theme_input(additional_classes = "")
    "theme-input #{additional_classes}".strip
  end
  
  # Helper method to generate theme badge classes
  def theme_badge(style = :primary, additional_classes = "")
    base_class = "theme-badge"
    style_class = "theme-badge-#{style}"
    
    "#{base_class} #{style_class} #{additional_classes}".strip
  end
  
  # Helper method to generate theme alert classes
  def theme_alert(style = :info, additional_classes = "")
    base_class = "theme-alert"
    style_class = "theme-alert-#{style}"
    
    "#{base_class} #{style_class} #{additional_classes}".strip
  end
end
