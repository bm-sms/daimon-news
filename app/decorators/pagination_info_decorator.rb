module PaginationInfoDecorator
  def page_entries_info
    if total_pages > 1
      first = offset_value + 1
      last  = last_page? ? total_count : offset_value + limit_value

      "#{first}〜#{last}/#{total_count}件"
    else
      "#{total_count}件"
    end
  end
end
