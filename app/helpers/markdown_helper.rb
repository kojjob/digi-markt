module MarkdownHelper
  # Simple markdown renderer that doesn't require external gems
  def markdown(text)
    return '' if text.blank?

    # Process the markdown text
    html = text.dup

    # Headers
    html.gsub!(/^# (.+)$/, '<h1>\1</h1>')
    html.gsub!(/^## (.+)$/, '<h2>\1</h2>')
    html.gsub!(/^### (.+)$/, '<h3>\1</h3>')
    html.gsub!(/^#### (.+)$/, '<h4>\1</h4>')

    # Bold and Italic
    html.gsub!(/\*\*(.+?)\*\*/, '<strong>\1</strong>')
    html.gsub!(/\*(.+?)\*/, '<em>\1</em>')

    # Lists
    html.gsub!(/^\- (.+)$/, '<li>\1</li>')
    html.gsub!(/<\/li>\n<li>/, '</li><li>')
    html.gsub!(/<li>(.+?)(<\/li>)(?!\n<li>)/, '<ul><li>\1\2</ul>')

    # Numbered lists
    html.gsub!(/^\d+\. (.+)$/, '<li>\1</li>')
    html.gsub!(/<\/li>\n<li>/, '</li><li>')
    html.gsub!(/<li>(.+?)(<\/li>)(?!\n<li>)/, '<ol><li>\1\2</ol>')

    # Links
    html.gsub!(/\[(.+?)\]\((.+?)\)/, '<a href="\2">\1</a>')

    # Code blocks
    html.gsub!(/`(.+?)`/, '<code>\1</code>')

    # Paragraphs (must be last)
    html.gsub!(/^(?!<h|<ul|<ol|<li|<\/ul>|<\/ol>)(.+)$/, '<p>\1</p>')

    # Return the HTML wrapped in a div
    content_tag(:div, html.html_safe, class: 'markdown-content')
  end

  # Simple plain text renderer
  def markdown_plain(text)
    return '' if text.blank?

    # Strip markdown syntax
    text.gsub(/[#*`\[\]\(\)]/, '')
  end
end
