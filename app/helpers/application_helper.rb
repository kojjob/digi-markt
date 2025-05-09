module ApplicationHelper
  # Check if the current page matches the given path
  def current_page?(path)
    request.path == path
  end
end
