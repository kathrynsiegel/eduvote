module ApplicationHelper

  # Creates the full title on a per-page basis.
  def create_title(page_title)
    base_title = "EDUvote"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

end
