module ParticipantsDecorator
  include PaginationInfoDecorator

  def page_title
    base_title = "すべての執筆関係者"
    if current_page > 1
      "#{base_title} (#{page_entries_info})"
    else
      base_title
    end
  end
end
