module SerialsDecorator
  def page_title
    base_title = "すべての連載"
    if current_page > 1
      "#{base_title} (#{page_entries_info})"
    else
      base_title
    end
  end
end
